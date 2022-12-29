// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EatOnBlock {
    struct Dish {
        string dishName;
        uint256 dishPriceInUSD;
    }

    Dish[] public dishes;
    Dish[] selectedDishes;
    Dish dish;
    uint256 total;
    string hotelName;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function createHotel(string memory _hotelName) public {
        require(msg.sender == owner, "U r not the Owner");
        hotelName = _hotelName;
    }

    function enterDish(string memory _dishName, uint256 _dishPriceUSD) public {
        require(msg.sender == owner, "U r not the Owner");
        dishes.push(Dish(_dishName, _dishPriceUSD));
    }

    function getDishes() public view returns (Dish[] memory) {
        return dishes;
    }

    function selectDishes(uint256 _index) public {
        total = total + dishes[_index].dishPriceInUSD;
        selectedDishes.push(dishes[_index]);
    }

    function getBill()
        public
        view
        returns (string memory, uint256, Dish[] memory)
    {
        return (hotelName, total, selectedDishes);
    }

    // function getHotelName() view public returns (string memory){
    //     return (hotelName);
    // }

    // function getSelectedDishes() view public returns (Dish[] memory){
    //     return (selectedDishes);
    // }

    // function getTotal() view public returns (uint256){
    //     return (total);
    // }

    function payBill() public payable {
        payable(msg.sender).transfer(total);
    }

    function withdrawBills() public payable {
        require(msg.sender == owner, "U r not the Owner");
        payable(owner).transfer(address(this).balance);
    }
}
