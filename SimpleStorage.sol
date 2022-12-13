// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {

    uint public variable;

    mapping(string => uint) public nametoFavnum;

    struct People{
        string name;
        uint256 number;
    }

    People[] public person;

    function storeperson(string memory _name, uint256 _favnum ) public {
        person.push(People(_name , _favnum));
        nametoFavnum[_name] = _favnum;

    }

}
