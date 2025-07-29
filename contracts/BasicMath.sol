// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BasicMath {
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        unchecked {
            sum = _a + _b;
        }

        if (sum < _a) {
            return (0, true);
        }

        return (sum, false);
    }

    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        if (_a < _b) {
            return (0, true);
        }

        return (_a - _b, false);
    }
}
