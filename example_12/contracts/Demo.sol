// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ILogger.sol";

contract Demo {
    ILogger logger;

    constructor(address _logger) {
        require(_logger != address(0), "Logger address cannot be zero");
        logger = ILogger(_logger);
    }

    function payment(address _from, uint _number) public view returns(uint) {
        return logger.getEntry(_from, _number);
    }

    receive() external payable {
        logger.log(msg.sender, msg.value);
    }
}
