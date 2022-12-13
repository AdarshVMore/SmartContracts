// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

    import "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;
    address public owner ;
    uint256 public minimumUSD = 50*1e10;
    address[] public sendersAddress;
    mapping(address => uint256) public senderTofund;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value > minimumUSD , "not send enough");

        //ABI 
        //Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        sendersAddress.push(msg.sender);
        senderTofund[msg.sender] = msg.value;
    }

    function withdraw() public payable{
        require(msg.sender == owner , "u r not the owner");

        for(uint i=0 ; i>sendersAddress.length ; i++){
            senderTofund[sendersAddress[i]] = 0;
        }

        sendersAddress = new address[](0);
        (bool callsuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callsuccess,"transfer failed");
    }
}
