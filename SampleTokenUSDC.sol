//SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "./node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SampleTokenUSDC is ERC20 ("USDCFake", "USDCF") {
    function mintTwenty() public {
        _mint(msg.sender, 20);
    }
}