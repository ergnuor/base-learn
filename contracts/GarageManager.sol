// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    error BadCarIndex(uint _index);

    function addCar(string calldata _make, string calldata _model, string calldata _color, uint _numberOfDoors) external {
        Car memory car = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });

        garage[msg.sender].push(car);
    }

    function getMyCars() external view returns(Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _userAddress) external view returns(Car[] memory) {
        return garage[_userAddress];
    }

    function updateCar(uint _index, string calldata _make, string calldata _model, string calldata _color, uint _numberOfDoors) external {
        Car[] storage senderCars = garage[msg.sender];

        if (_index > senderCars.length) {
            revert BadCarIndex(_index);
        }

        senderCars[_index] = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
