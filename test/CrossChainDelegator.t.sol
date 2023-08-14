// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CrossChainDelegator.sol";

uint256 constant ZORA_MINT_FEE = 0.000777 ether;

contract CrossChainDelegatorTest is Test {
  CrossChainDelegator public ccd;
  function setUp() public {
    ccd = new CrossChainDelegator();
  }
  function testSetup() public {
    uint256 quantity = 1;
    bytes32[3] memory data;
    uint256 price = 0.1 ether;
    ccd.setup{value: price + ZORA_MINT_FEE}(quantity, data);
  }
}
