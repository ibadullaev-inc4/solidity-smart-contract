// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//Merkle Tree
contract Tree {
    bytes32[] public hashes;
    string[4] transaction = [
        "TX1: Sherlok -> John",
        "TX2: John -> Sherlok",
        "TX3: John -> Mary",
        "TX4: Mary -> Sherlok"
    ];

    constructor() {
        for(uint i = 0 ; i < transaction.length; i++ ) {
            hashes.push(makeHash(transaction[i]));
        }

        uint count = transaction.length;
        uint offset = 0;

        while (count > 0) {
            for (uint i=0; i< count -1 ; i+=2) { 
                hashes.push(
                    makeHash(
                        abi.encodePacked( hashes[offset+i], hashes[offset+i+1] )
                    )
                ); 
            }
            offset += count;
            count = count /2;

        }
    }

    function encode(string memory input) public pure returns(bytes memory) {
        return abi.encodePacked(input);
    }

    function makeHash(string memory input) public pure  returns(bytes32) {
        return  keccak256(
            encode(input)
        );
    }
}
