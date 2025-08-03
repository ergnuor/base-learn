// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] public senders;
    uint[] public timestamps;

    uint private afterY2KTimestampsCount;

    uint private thresholTimestamp = 946702800;

    function getNumbers() external view returns (uint[] memory) {
        return numbers;
    }

    function resetNumbers() external {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    function appendToNumbers(uint[] memory _toAppend) external {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) external {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);

        if (_unixTimestamp > thresholTimestamp) {
            afterY2KTimestampsCount++;
        }
    }

    function afterY2K() external view returns(uint[] memory, address[] memory) {
        uint[] memory desiredTimestamps = new uint[](afterY2KTimestampsCount);
        address[] memory desiredSenders = new address[](afterY2KTimestampsCount);
        uint cursor;

        for(uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > thresholTimestamp) {
                desiredSenders[cursor] = senders[i];
                desiredTimestamps[cursor] = timestamps[i];
                cursor++;
            }
        }

        return (desiredTimestamps, desiredSenders);
    }

    function resetSenders() external {
        delete senders;
    }

    function resetTimestamps() external {
        delete timestamps;
    }
}
