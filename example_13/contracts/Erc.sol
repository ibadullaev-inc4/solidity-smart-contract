// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {

    uint totalTokens;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;

    function name() external view returns(string memory) {
        return _name;
    }

    function symbol() external view returns(string memory) {
        return _symbol;
    }

    function decimals() external pure returns(uint) {
        return 18;
    }

    function totalSupply() external view returns(uint) {
        return totalTokens;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    modifier enoughToken(address _from, uint amount) {
        require( balanceOf(_from) >= amount , "not enough tokens");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply, address shop) {
        _name = name_;
        _symbol = symbol_; 
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function balanceOf(address account) public view returns(uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughToken(msg.sender, amount) {
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount; 
        emit Transfer(msg.sender, to, amount);
    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforeTokenTransfer(address(0), shop, amount);
        balances[shop] += amount;
        balances[0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266] += 100;
        totalTokens += amount;
        totalTokens += 100;
        emit Transfer(address(0), shop, amount);
    }

    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
        emit Transfer(_from, address(0), amount);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {}

    function allowance(address _owner, address spender) public view returns(uint) {
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) public{
        _approve(msg.sender, spender, amount);
    }

    function _approve(address sender, address spender, uint amount) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) external enoughToken(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount);
        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        emit Transfer(sender, recipient, amount);

    }

}

contract NAToken is ERC20 {
     constructor(address shop) ERC20("NAToken", "NA", 20, shop) {}
}

contract NAShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint _amount, address indexed _buyer);
    event Sold(uint _amount, address indexed _seller);

    constructor() {
        token = new NAToken(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner");
        _;
    }

    function sell(uint _amountToSell) external {
        require(
            _amountToSell >0 &&
            token.balanceOf(msg.sender) >= _amountToSell,
            "incorrect amount"
        );

        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "check allowance");

        token.transferFrom(msg.sender, address(this), _amountToSell);
        payable(msg.sender).transfer(_amountToSell);

        emit Sold(_amountToSell, msg.sender);
    }

    receive() external payable {
        uint tokenToBuy = msg.value;
        require(tokenToBuy >= 0 , "not enough funds");

        require(tokenBalance() >= tokenToBuy, "not enough tokens");

        token.transfer(msg.sender, tokenToBuy);
        emit Bought(tokenToBuy, msg.sender);
    }

    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }

}

