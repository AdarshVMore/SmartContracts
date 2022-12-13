// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

contract StorageFactory{

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStoragecontract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfadd(uint256 _sfindex , uint256 _sfnumber) public{
        SimpleStorage simpleStorage = simpleStorageArray[_sfindex];
        simpleStorage.store(_sfnumber);       

    }

    function sfget(uint256 _simplestorageindex) public view returns(uint256) {
        SimpleStorage getsimpleStorage = simpleStorageArray[_simplestorageindex];
        return getsimpleStorage.retrieve();
    }



}
