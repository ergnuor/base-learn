// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ControlStructures {
    error AfterHours(uint256 timeProvided);

    function fizzBuzz(uint256 _number) external pure returns (string memory) {
        if (_number % 3 == 0) {
            if (_number % 5 == 0) {
                return "FizzBuzz";
            }

            return "Fizz";
        }

        if (_number % 5 == 0) {
            return "Buzz";
        }

        return "Splat";
    }

    function doNotDisturb(uint256 _time) external pure returns (string memory) {
        assert(_time < 2400);

        if (_time < 800 || _time > 2200) {
            revert AfterHours(_time);
        }

        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }

        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }

        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }

        return "Evening!";
    }
}
