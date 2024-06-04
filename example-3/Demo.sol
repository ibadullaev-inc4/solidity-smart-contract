// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {

    address public myAddr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    mapping (address => uint) public payments;

    string public myStr = "test"; //storage

    function demo(string memory newArgString) public {
        string memory myTempStr = "temp";
        myStr = newArgString;
    }

    function getBalance(address targetAddress) public  view returns(uint) {
        return targetAddress.balance;
    }

    function receiveFunds() public payable {
        payments[msg.sender] = msg.value;
    }

    function transferTo(address payable  toAddress, uint amount) public {
        toAddress.transfer(amount);
    }
}