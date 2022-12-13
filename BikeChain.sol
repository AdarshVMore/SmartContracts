// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BikeChain{

    string public firstName;
    string public lastName;
    uint256 public creditAcc;
    uint256 public payDue;
    address public owner;
    address public bikeOwner = 0xF51D5fa269148B004c6cfB2afdFC1Fe408A3A261;

    function getName(string memory fname , string memory lname) public {
        firstName = fname;
        lastName = lname;
    }

    function connectWallet() public{
        owner = msg.sender; 
    }

    function credit() payable public{
        creditAcc = msg.value;
    }

    function due(uint dueAmount) payable public{
        if(dueAmount <= creditAcc && dueAmount <= payDue){
            payDue = payDue - dueAmount;
            creditAcc = creditAcc - dueAmount;
            (bool success , ) = payable(bikeOwner).call{value:dueAmount}("");
            // address(this).balance = address(this).balance - dueAmount
            require(success , "txn aint sucessfull");
        }
    }

    function checkOut(uint256 time) public returns (uint256){
        payDue = time * 2e10;
        return payDue;
    }
}
