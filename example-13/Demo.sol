// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ownable {
    address public owner;

    constructor(address ownerOverride) {
        owner = ownerOverride == address(0) ? msg.sender : ownerOverride;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not an owner!");
        _;
    }
    function withdrow(address payable _to) public virtual  onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}


abstract contract Balances is Ownable {
    function getBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }

    function withdrow(address payable _to) public override virtual  onlyOwner {
        _to.transfer(getBalance());
    }
}

contract Demo is Ownable, Balances {
    constructor() Ownable(msg.sender) {

    }

    function withdrow(address payable _to) public override(Ownable, Balances) onlyOwner {
        require(_to != address(0), "can;t zore address");
        super.withdrow(_to);

    }

}