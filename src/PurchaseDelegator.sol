// SPDX-License-Identifier: AGPL-3.0
// GitHub: https://github.com/attestate/checkout-portal
pragma solidity ^0.8.13;

address constant collectionLocation = 0x66747bdC903d17C586fA09eE5D6b54CC85bBEA45;
interface IERC721Drop {
  function mintWithRewards(
    address recipient,
    uint256 quantity,
    string calldata comment,
    address mintReferral
  ) external payable returns (uint256);
  function purchaseWithRecipient(
    address recipient,
    uint256 quantity,
    string calldata comment
  ) payable external returns (uint256);
}
address constant delegator2Location = 0x08b7ECFac2c5754ABafb789c84F8fa37c9f088B0;
interface Delegator2 {
  function etch(bytes32[3] calldata data) external;
}

contract PurchaseDelegator {
  function setup(uint256 quantity, bytes32[3] calldata data, string calldata comment, address referral) external payable {
    IERC721Drop collection = IERC721Drop(collectionLocation);
    Delegator2 delegator2 = Delegator2(delegator2Location);
    collection.mintWithRewards{value: msg.value}(msg.sender, quantity, comment, referral);
    delegator2.etch(data);
  }
}
