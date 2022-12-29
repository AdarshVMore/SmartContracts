// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EatOnBlockHotel{
    address owner;
    struct Dish {
        string dishName;
        uint256 dishPriceInUSD;
    }

    Dish[] public dishes;
    
    string hotelName;

    constructor(){
        owner = msg.sender;
    }

    
    function createHotel(string memory _hotelName) public {
        require(msg.sender == owner , "U r not the Owner");
        hotelName = _hotelName;
    }
    
    function enterDish(string memory _dishName , uint256 _dishPriceUSD) public{
        require(msg.sender == owner , "U r not the Owner");
        dishes.push(Dish(_dishName , _dishPriceUSD) );
    }

    function getDishes() view public returns (Dish[] memory){
        return dishes;
    }

    function withdrawBills() payable public{
        require(msg.sender == owner , "U r not the Owner");
        payable(owner).transfer(address(this).balance);
    }
}