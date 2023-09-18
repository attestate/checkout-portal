// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PurchaseDelegator.sol";

uint256 constant ZORA_MINT_FEE = 0.000777 ether;

contract PurchaseDelegatorTest is Test {
  PurchaseDelegator public pd;
  function setUp() public {
    pd = new PurchaseDelegator();
  }
  function testSetup() public {
    uint256 quantity = 1;
    bytes32[3] memory data;
    uint256 price = 0.00666 ether;
    string memory comment = "hello";
    address referral = 0x0000000000000000000000000000000000001337;
    pd.setup{value: price + ZORA_MINT_FEE}(quantity, data, comment, referral);
  }
}
