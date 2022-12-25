// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract chai{


    address payable owner;
    uint256 public perChai = 9900000000000;
    uint256 public value;

    struct Memo{
        string name;
        string message;
        uint noOfChai;
        address sender;
        uint timestamp;

    }
    Memo[] memos;

    constructor(){
        owner = payable(msg.sender);
    }

    function enterInfo(string memory _name , string memory _message ,uint256 _noOfChai) public {
        memos.push(Memo(_name , _message , _noOfChai ,msg.sender , block.timestamp));
        value = _noOfChai * perChai; 
    }

    function payForChai(uint256 amount) public payable{
        require(msg.value >= value, "havent send enough");
        (bool success , ) = payable(owner).call{value: amount}("");
        require(success , "txn aint sucessfull");

    }

    function getMemo() view public returns (Memo[] memory){
        return memos;

    }
}