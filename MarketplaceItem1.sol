//SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import "./node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract MarketplaceItem1 {

AggregatorV3Interface internal priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);

    mapping(address => bool) public hasPurchased;
    uint public price = 10 * 10 ** 18;
    address payable public owner;

    IERC20 public usdcFake = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
    IERC20 public usdtFake = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);

    constructor () {
        owner = payable(msg.sender);
    }

    function payInUSDC() public returns (bool) {
        address callerWalletAddress = msg.sender;
        require(!hasPurchased[callerWalletAddress], "You have already bought this item!");
        usdcFake.transferFrom(callerWalletAddress, owner, price);
        hasPurchased[callerWalletAddress] = true;
        return hasPurchased[callerWalletAddress];

    }

    function payInUSDT() public returns (bool) {
        address callerWalletAddress = msg.sender;
        require(!hasPurchased[callerWalletAddress], "You have already bought this item!");
        usdtFake.transferFrom(callerWalletAddress, owner, price);
        hasPurchased[callerWalletAddress] = true;
        return hasPurchased[callerWalletAddress];

    }

    function getCurrentPriceOfETH() public view returns (int) {
        (, int priceInUSD,,,) = priceFeed.latestRoundData();
        return priceInUSD / 10 ** 8;
    }

    function getPriceOfETH() public view returns(int) {
        return int(price) / getCurrentPriceOfETH();
    }

    function payInEth() public payable returns(bool) {
        address callerWalletAddress = msg.sender;
        uint paymentAmount = msg.value;
        require(int(paymentAmount) == getPriceOfETH(), "You are not sending the correct amount!");
        hasPurchased[callerWalletAddress] == true;
        // move the eth into the owner's account
        (bool success, /*Data*/) = owner.call{value: paymentAmount}("");
        require(success, "Payment not successful");
        return success;
    }
}