// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    error HaikuNotUnique();
    error NotYourHaiku(uint _haikuId);
    error NoHaikusShared();

    Haiku[] public haikus;
    mapping(address => uint[]) public sharedHaikus;
    uint public counter;

    mapping(bytes32 => bool) private usedLines;

    constructor () ERC721("Ergnuor", "ERG") {
        haikus.push();
        counter = 1;
    }

    function mintHaiku(string calldata _line1, string calldata _line2, string calldata _line3) external {
        bytes32 line1Hash = keccak256(bytes(_line1));
        bytes32 line2Hash = keccak256(bytes(_line2));
        bytes32 line3Hash = keccak256(bytes(_line3));

        if (
            usedLines[line1Hash] ||
            usedLines[line2Hash] ||
            usedLines[line3Hash]
        ) {
            revert HaikuNotUnique();
        }

        usedLines[line1Hash] = true;
        usedLines[line2Hash] = true;
        usedLines[line3Hash] = true;

        haikus.push(
            Haiku({
                author: _msgSender(),
                line1: _line1,
                line2: _line2,
                line3: _line3
            })
        );

        _safeMint(_msgSender(), counter);
        counter++;
    }

    function shareHaiku(uint _haikuId, address _to) public {
        if (ownerOf(_haikuId) != _msgSender()) {
            revert NotYourHaiku(_haikuId);
        }

        sharedHaikus[_to].push(_haikuId);
    }

    function getMySharedHaikus() public view returns(Haiku[] memory) {
        uint[] memory sharedHaikuIds = sharedHaikus[_msgSender()];
        uint length = sharedHaikuIds.length;

        if (length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory resultHaikus = new Haiku[](length);

        for(uint i = 0; i < length; i++) {
            resultHaikus[i] = haikus[sharedHaikuIds[i]];
        }

        return resultHaikus;
    }
}
