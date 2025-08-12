// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract UnburnableToken {
    mapping (address => uint) public balances;
    uint public totalSupply;
    uint public totalClaimed;
    mapping(address => bool) public alreadyClaimed;

    uint public constant CLAIM_AMOUNT = 1000;

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address _to);
    error InsufficientBalance();

    constructor() {
        totalSupply = 100_000_000;
    }

    function claim() external {
        if (alreadyClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalClaimed + CLAIM_AMOUNT > totalSupply) {
            revert AllTokensClaimed();
        }

        balances[msg.sender] += CLAIM_AMOUNT;
        totalClaimed += CLAIM_AMOUNT;

        alreadyClaimed[msg.sender] = true;
    }

    function safeTransfer(address _to, uint _amount) external {
        if (
            _to == address(0) ||
            _to.balance == 0
        ) {
            revert UnsafeTransfer(_to);
        }

        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance();
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
