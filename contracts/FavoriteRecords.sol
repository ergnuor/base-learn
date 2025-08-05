// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract FavoriteRecords {
    error NotApproved(string _albumName);

    mapping(string => bool) public approvedRecords;
    string[] private approvedRecordsList;
    mapping (address => mapping(string => bool)) public userFavorites;
    mapping (address => string[]) private userFavoritesList;

    constructor() {
        approvedRecordsList = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        for (uint i = 0; i < approvedRecordsList.length; i++) {
            approvedRecords[approvedRecordsList[i]] = true;
        }
    }

    function getApprovedRecords() external view returns (string[] memory) {
        return approvedRecordsList;
    }

    function addRecord(string calldata _albumName) external {
        if (approvedRecords[_albumName] == false) {
            revert NotApproved(_albumName);
        }


        if (userFavorites[msg.sender][_albumName] == false) {
            userFavorites[msg.sender][_albumName] = true;
            userFavoritesList[msg.sender].push(_albumName);
        }
    }

    function getUserFavorites(address _user) external view returns(string[] memory) {
        return userFavoritesList[_user];
    }

    function resetUserFavorites() external {
        string[] storage senderFavoritesList = userFavoritesList[msg.sender];

        for (uint i = 0; i < senderFavoritesList.length; i++) {
            userFavorites[msg.sender][senderFavoritesList[i]] = false;
        }

        delete userFavoritesList[msg.sender];
    }
}