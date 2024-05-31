// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyDemo {

    uint public minimum;
    uint8 public maximum;
    uint8 public myVal = 254;

    bool public myBool; //state

    function demoMin() public  {
        minimum = type(uint).min;
    }

    function demoMax() public  {
        maximum = type(uint8).max;
    }

    function inc() public {
        myVal++;
    }

    function incUnchecked() public {
        unchecked{
            myVal++;
        }
    }

}