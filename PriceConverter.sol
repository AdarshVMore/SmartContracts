// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter{
    function getPrice() internal  view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = pricefeed.latestRoundData();
        return uint256(price * 1e10);
    }   

    function version() internal view  returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return pricefeed.version();

    }

    function getConversionPrice(uint ethamount) internal  view returns(uint256){
        uint256 ethprice = getPrice();
        return ((ethprice * ethamount) / 1e18);

    }

}
