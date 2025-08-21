// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

using EnumerableSet for EnumerableSet.AddressSet;

contract WeightedVoting is ERC20 {
    uint private constant CLAIM_AMOUNT = 100;

    uint public maxSupply;

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] issues;

    enum Vote {AGAINST, FOR, ABSTAIN}

    EnumerableSet.AddressSet alreadyClaimedAddresses;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint _quorum);
    error AlreadyVoted();
    error VotingClosed();
    error UnknownVote();

    constructor() ERC20("Ergnuor", "ERG") {
        maxSupply = 1_000_000;

        issues.push();
        issues[0].closed = true;
    }
    
    function decimals() public override pure returns (uint8) {
        return 0;
    }

    function claim() public {
        if (alreadyClaimedAddresses.contains(_msgSender())) {
            revert TokensClaimed();
        }

        uint amount = CLAIM_AMOUNT;

        if (totalSupply() + amount > maxSupply) {
            revert AllTokensClaimed();
        }

        _mint(_msgSender(), amount);
        alreadyClaimedAddresses.add(_msgSender());
    }

    function createIssue(string calldata _issueDesc, uint _quorum) external returns(uint) {
        if (balanceOf(_msgSender()) == 0) {
            revert NoTokensHeld();
        }

        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }
        
        Issue storage issueRef = issues.push();
        issueRef.issueDesc = _issueDesc;
        issueRef.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint _id) external view returns(ReturnableIssue memory) {
        Issue storage issueRef = issues[_id];

        uint votesrCount = issueRef.voters.length();
        address[] memory voters = new address[](votesrCount);

        for(uint i = 0; i < votesrCount; i++) {
            voters[i] = issueRef.voters.at(i);
        }

        return ReturnableIssue({
            voters: voters,
            issueDesc: issueRef.issueDesc,
            votesFor: issueRef.votesFor,
            votesAgainst: issueRef.votesAgainst,
            votesAbstain: issueRef.votesAbstain,
            totalVotes: issueRef.totalVotes,
            quorum: issueRef.quorum,
            passed: issueRef.passed,
            closed: issueRef.closed
        });
    }

    function vote(uint _issueId, Vote _vote) external {
        Issue storage issueRef = issues[_issueId];

        if (issueRef.voters.contains(_msgSender())) {
            revert AlreadyVoted();
        }

        if (issueRef.closed) {
            revert VotingClosed();
        }

        uint voteAmount = balanceOf(_msgSender());

        if (voteAmount == 0) {
            revert NoTokensHeld();
        }

        if (_vote == Vote.AGAINST) {
            issueRef.votesAgainst += voteAmount;
        } else if (_vote == Vote.FOR) {
            issueRef.votesFor += voteAmount;
        } else if (_vote == Vote.ABSTAIN) {
            issueRef.votesAbstain += voteAmount;
        } else {
            revert UnknownVote();
        }

        issueRef.totalVotes += voteAmount;

        issueRef.voters.add(_msgSender());

        if (issueRef.totalVotes >= issueRef.quorum) {
            issueRef.closed = true;

            if (issueRef.votesFor > issueRef.votesAgainst) {
                issueRef.passed = true;
            }
        }
    }
}