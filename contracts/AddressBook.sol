// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    Contact[] public contacts;
    mapping(uint => uint) public idIndexMap;

    error ContactAlreadyExists(uint _id);
    error ContactNotFound(uint _id);

    constructor(address _initialOwner) Ownable(_initialOwner) {}

    function addContact(
        uint _id,
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers
    ) external onlyOwner {
        uint index = idIndexMap[_id];

        if (index != 0) {
            revert ContactAlreadyExists(_id);
        }

        contacts.push(
            Contact({
                id: _id,
                firstName: _firstName,
                lastName: _lastName,
                phoneNumbers: _phoneNumbers
            })
        );

        idIndexMap[_id] = contacts.length;
    }

    function deleteContact(uint _id) external onlyOwner {
        uint index = idIndexMap[_id];

        if (index == 0) {
            revert ContactNotFound(_id);
        }

        contacts[index - 1] = contacts[contacts.length - 1];
        contacts.pop();

        delete idIndexMap[_id];
    }

    function getContact(uint _id) external view returns(Contact memory) {
        uint index = idIndexMap[_id];

        if (index == 0) {
            revert ContactNotFound(_id);
        }

        return contacts[index - 1];
    }

    function getAllContacts() external view returns (Contact[] memory) {
        return contacts;
    }
}

contract AddressBookFactory {
    function deploy() external returns(address) {
        AddressBook addressBook = new AddressBook(msg.sender);
        return address(addressBook);
    }
}
