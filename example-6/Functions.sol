// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    //public
    //external
    //internal
    //private

    //view
    //pure

    //call
    function getBalance() public view returns(uint balance) {
        balance = address(this).balance;
        // return balance;
    }

    string message = "Hello";

    function getMessage() external view returns(string memory) {
        return message;
    }

    function rate(uint amount) public pure returns(uint) {
        return amount * 3 ;
    }

    //transaction
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
}