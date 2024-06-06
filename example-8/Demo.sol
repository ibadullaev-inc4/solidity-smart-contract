// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    //revert
    //assert
    //require

    address owner;
    event Paid(address indexed  _from, uint amount, uint timestamp);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable { 
        pay();
    }

    modifier onlyOwner(address _to) {
        require(msg.sender == owner, "you are not an owner");
        require(_to != address(0), "incorrect address");
        _;
    }

    function pay() public payable {
        emit Paid(msg.sender, msg.value, block.timestamp);
    }

    function withdrawOnlyOwner(address payable _to) external onlyOwner(_to) {
        _to.transfer(address(this).balance);
    }

    function withdrawAssert(address payable _to) external {
        assert(msg.sender == owner);
        _to.transfer(address(this).balance);
    }

    function withdrawRequire(address payable _to) external {
        require(msg.sender == owner, "you are not an owner");
        _to.transfer(address(this).balance);
    }

    function withdrawRevert(address payable _to) external {
        if (msg.sender == owner) {
            revert("you are not an owner");
        }
        _to.transfer(address(this).balance);
    }


}