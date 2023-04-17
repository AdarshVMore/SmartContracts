// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Loyalty is ERC20{

    address contractOwner;
    uint orderNumber = 0;
    string[] gubblieNFTs;
    string[] badgesNfts;
    uint256 private ethToCoffeeBeanRatio = 5000; // 1 ETH = 5000 CoffeeBeans


    constructor() ERC20("CoffeeBean", "CB") {
        contractOwner = msg.sender;
    }

    struct Customer {
        address customer_address;
        string funkyName;
        string tier;
        uint overAllPoints;
        uint coffeeBeans;
        string[] orders;
        string[] badges;
        string[] NFTs;
    }

    Customer[] public customers;
    address[] public allCustomers;
    address[] public owners = [0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2];

    mapping(address => Customer) addressToCustomer;

    function topUp() external payable {
        uint256 coffeeBeanAmount = (msg.value * ethToCoffeeBeanRatio) / 10**18;
        _mint(msg.sender, coffeeBeanAmount);
    }

    function addNft(string memory _hash, uint _designation) public {
        if(_designation == 0){
            gubblieNFTs.push(_hash);
        }
        if(_designation == 1){
            badgesNfts.push(_hash);
        }
    }

    function addCustomer(string memory _funkyName) public{

        allCustomers.push(msg.sender);
        addressToCustomer[msg.sender].customer_address = msg.sender;
        addressToCustomer[msg.sender].funkyName = _funkyName;
        addressToCustomer[msg.sender].overAllPoints = 0;
        addressToCustomer[msg.sender].tier = "bronze";
        addressToCustomer[msg.sender].coffeeBeans = 0;
        customers.push(Customer(msg.sender, _funkyName, "bronze", 0, 0, new string[](0), new string[](0), new string[](0)));
    }

    function earnPoints(address _customer, string memory items, uint _bill) public returns(uint){

        bool isOwner = false;
        for(uint i=0 ; i<owners.length ; i++) {
            if(msg.sender == owners[i]) {
                isOwner = true;
            }
        }

        require(isOwner, "You are not the owner");
        uint pointsToAdd = _bill % 20;  //100 rs spent = 5 points got
        addressToCustomer[_customer].overAllPoints += pointsToAdd;
        addressToCustomer[_customer].orders.push(items);
        orderNumber++;
        gubblieOrder(_customer);
        return(addressToCustomer[_customer].overAllPoints);
    }

    function giveTier(address _address) public {
        uint currentPoints = addressToCustomer[_address].overAllPoints;
        if(currentPoints >= 1000) {
            addressToCustomer[_address].tier = "Platinum";
            addressToCustomer[_address].badges.push(badgesNfts[3]);
        }
        else if(currentPoints >= 600) {
            addressToCustomer[_address].tier = "Golden";
            addressToCustomer[_address].badges.push(badgesNfts[2]);

        }
        else if(currentPoints >= 250) {
            addressToCustomer[_address].tier = "Silver";
            addressToCustomer[_address].badges.push(badgesNfts[1]);

        }
        else {
            addressToCustomer[_address].tier = "bronze";
            addressToCustomer[_address].badges.push(badgesNfts[0]);

        }   
    }

    function gubblieOrder(address _address) public {
        if (orderNumber == 100) {
            addressToCustomer[_address].NFTs.push(gubblieNFTs[0]);
        }
        if (orderNumber == 250) {
            addressToCustomer[_address].NFTs.push(gubblieNFTs[1]);
        }
        if (orderNumber == 500) {
            addressToCustomer[_address].NFTs.push(gubblieNFTs[2]);
        }
    }

    function getCustomer(address _address) public view returns(Customer memory) {
        return addressToCustomer[_address];
    }

    function getCustomerList() public view returns(address[] memory) {
        return allCustomers;
    }
}