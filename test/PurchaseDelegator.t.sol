// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PurchaseDelegator.sol";

contract PurchaseDelegatorTest is Test {
  PurchaseDelegator public pd;
  function setUp() public {
    pd = new PurchaseDelegator();
  }
  function testUnderpay() public {
    address collection = 0x66747bdC903d17C586fA09eE5D6b54CC85bBEA45;
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.adminMint.selector),
        abi.encode(1)
    );
    uint256 price = 2 ether;
    IERC721Drop.SaleDetails memory details = IERC721Drop.SaleDetails(
      false,
      false,
      price,
      0,
      0,
      0,
      0,
      bytes32(0),
      0,
      0,
      0);
    bytes32[3] memory data;
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.saleDetails.selector),
        abi.encode(details)
    );

    address[] memory recipients = new address[](1);
    uint256[] memory values = new uint256[](1);

    vm.expectRevert(PurchaseDelegator.ErrValue.selector);
    pd.setup{value: price - 1 ether}(data, recipients, values);
  }
  function testPayWithoutRemainder() public {
    address collection = 0x66747bdC903d17C586fA09eE5D6b54CC85bBEA45;
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.adminMint.selector),
        abi.encode(1)
    );
    uint256 price = 0.1 ether;
    IERC721Drop.SaleDetails memory details = IERC721Drop.SaleDetails(
      false,
      false,
      price,
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
    bytes32[3] memory data;
    address[] memory recipients = new address[](1);
    uint256[] memory values = new uint256[](1);

    uint256 surplus = 0;
    pd.setup{value: price + surplus}(data, recipients, values);
  }
  function testSetup() public {
    address collection = 0x66747bdC903d17C586fA09eE5D6b54CC85bBEA45;
    vm.mockCall(
        collection,
        abi.encodeWithSelector(IERC721Drop.adminMint.selector),
        abi.encode(1)
    );
    uint256 price = 0.1 ether;
    IERC721Drop.SaleDetails memory details = IERC721Drop.SaleDetails(
      false,
      false,
      price,
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
    bytes32[3] memory data;

    address[] memory recipients = new address[](2);
    recipients[0] = 0xee324c588ceF1BF1c1360883E4318834af66366d;
    recipients[1] = 0x3e6c23CdAa52B1B6621dBb30c367d16ace21F760;

    uint256[] memory values = new uint256[](2);
    values[0] = 0.01 ether;
    values[1] = 0.02 ether;

    pd.setup{value: price + values[0] + values[1]}(data, recipients, values);
  }
}
