// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

address constant nft = 0xebB15487787cBF8Ae2ffe1a6Cca5a50E63003786;
interface IERC721Drop {
  function purchase(uint256 quantity) external payable returns (uint256);
}

// https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/src/universal/CrossDomainMessenger.sol
address constant cdm = 0x25ace71c97B33Cc4729CF772ae268934F7ab5fA1;
interface ICrossDomainMessenger {
  function sendMessage(
    address _target,
    bytes calldata _message,
    uint32 _minGasLimit
  ) external payable;
}

address constant delegator2 = 0x08b7ECFac2c5754ABafb789c84F8fa37c9f088B0;

contract CrossChainDelegator {
  function setup(uint256 quantity, bytes32[3] calldata data) external payable {
    IERC721Drop collection = IERC721Drop(nft);
    collection.purchase{value: msg.value}(quantity);
    ICrossDomainMessenger optimismCdm = ICrossDomainMessenger(cdm);
    uint32 gasLimit = 30000;
    optimismCdm.sendMessage(
      delegator2,
      abi.encodeWithSignature(
        "etch(bytes32[3])",
        data
      ),
      gasLimit
    );
  }
}
