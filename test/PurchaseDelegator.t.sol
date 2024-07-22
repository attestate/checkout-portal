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
  function testInvite() public {
    address collection = 0x66747bdC903d17C586fA09eE5D6b54CC85bBEA45;
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.adminMint.selector),
        abi.encode(1)
    );
    IERC721Drop.SaleDetails memory details = IERC721Drop.SaleDetails(
      false,
      false,
      0.1 ether,
      0,
      0,
      0,
      0,
      bytes32(0),
      0,
      0,
      0);
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.saleDetails.selector),
        abi.encode(details)
    );
    uint256 price = 0.1 ether;
    address recipient = 0x0000000000000000000000000000000000001337;
    pd.invite{value: price}(payable(recipient));
  }
  function testSetup() public {
    address collection = 0x66747bdC903d17C586fA09eE5D6b54CC85bBEA45;
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.adminMint.selector),
        abi.encode(1)
    );
    IERC721Drop.SaleDetails memory details = IERC721Drop.SaleDetails(
      false,
      false,
      0.1 ether,
      0,
      0,
      0,
      0,
      bytes32(0),
      0,
      0,
      0);
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.saleDetails.selector),
        abi.encode(details)
    );
    address delegator = 0x08b7ECFac2c5754ABafb789c84F8fa37c9f088B0;
    vm.mockCall(
        delegator,
        abi.encodeWithSelector(Delegator2.etch.selector),
        abi.encode(0)
    );
    uint256 quantity = 1;
    bytes32[3] memory data;
    uint256 price = 0.1 ether;
    pd.setup{value: price}(quantity, data);
  }
}
