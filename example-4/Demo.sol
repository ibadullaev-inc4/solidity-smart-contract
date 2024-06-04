// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {

    //Struct

    struct Payment {
        uint amount;
        uint timestamp;
        address from;
        string message;
    }

    struct Balance {
        uint totalPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) public balances;

    function payTest(string memory message) public payable {

        uint paymentNumber = balances[msg.sender].totalPayments;
        balances[msg.sender].totalPayments++;
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );
        balances[msg.sender].payments[paymentNumber] = newPayment;
    }

    function getTestPayment(address _addr, uint _index) public view returns(Payment memory) {
        return balances[_addr].payments[_index];  
    }

    //Bytes
    bytes32 public myVar = "test here";
    bytes public myDynamicVar = unicode"привет мир!!!";
    bytes public myDynamicVar1 = "test here";

    function demoLenMyVar() public view  returns(uint) {
        return myVar.length;
    }

    function demoLenMyDynamicVar() public view  returns(uint) {
        return myDynamicVar.length;
    }

    function demoLenMyDynamicVar1() public view  returns(bytes1) {
        return myDynamicVar1[0];
    }


    // Array
    uint[] public numbers;
    uint public len;

    function populateNumbersArray() public {
        numbers.push(4);
        numbers.push(5);
        numbers.push(6);
        len = numbers.length;
    }

    function sampleMemory() public view returns(uint[] memory) {
        uint[] memory tempArray = new uint[](10);
        tempArray[0] = 100;
        tempArray[1] = 200;
        return tempArray;
    }

    string[5] public Text;

    uint[10] public items = [1,2,3] ;

    uint[][] public digits;

    function populateDigitsArray() public {
        digits = [
            [3,4,5],
            [6,7,8]
        ];
    }

    function demo() public {
        items[3] = 40;
        items[5] = 60;
        items[7] = 80;
    }


    //Enum
    enum Status { Paid, Delivered, Received }
    Status public currentStatus;
    
    function pay() public {
        currentStatus = Status.Paid;
    }

    function delivered() public {
        currentStatus = Status.Delivered;
    }

    function received() public {
        currentStatus = Status.Received;
    }

}