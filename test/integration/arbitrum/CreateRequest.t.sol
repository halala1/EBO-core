// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import './IntegrationBase.t.sol';

contract IntegrationCreateRequest is IntegrationBase {
  function setUp() public override {
    super.setUp();

    // Set modules data
    _setRequestModuleData();
    _setResponseModuleData();
    _setDisputeModuleData();
    _setResolutionModuleData();
  }

  function test_CreateRequest() public {
    IOracle.Request memory _requestData = _instantiateRequestData();

    // Should revert if the requester is not the EBORequestCreator
    vm.expectRevert(IEBORequestModule.EBORequestModule_InvalidRequester.selector);
    vm.prank(_requester);
    _requestData.requester = _requester;
    oracle.createRequest(_requestData, '');

    // Should revert if the epoch is invalid
    vm.expectRevert(IEBORequestCreator.EBORequestCreator_InvalidEpoch.selector);
    vm.prank(_requester);
    eboRequestCreator.createRequest(1, _chainId);

    // Create a request without approving the chain ID
    vm.expectRevert(IEBORequestCreator.EBORequestCreator_ChainNotAdded.selector);
    vm.prank(_requester);
    eboRequestCreator.createRequest(_currentEpoch, _chainId);

    // Add chain IDs
    _addChains();

    // Check that oracle is creating the request with the correct chain ID and epoch
    IEBORequestModule.RequestParameters memory _requestParams = _instantiateRequestParams();
    _requestParams.epoch = _currentEpoch;
    _requestParams.chainId = _chainId;
    _requestData.requestModuleData = abi.encode(_requestParams);
    _requestData.requester = address(eboRequestCreator);

    // Expect the oracle to create the request
    vm.expectCall(address(oracle), abi.encodeWithSelector(IOracle.createRequest.selector, _requestData, bytes32(0)));

    vm.prank(_requester);
    eboRequestCreator.createRequest(_currentEpoch, _chainId);
    bytes32 _requestId = eboRequestCreator.requestIdPerChainAndEpoch(_chainId, _currentEpoch);

    // Check that the request ID is stored correctly
    assertEq(oracle.requestCreatedAt(_requestId), block.timestamp);

    // Expect revert if the request is already created
    vm.prank(_requester);
    vm.expectRevert(IEBORequestCreator.EBORequestCreator_RequestAlreadyCreated.selector);
    eboRequestCreator.createRequest(_currentEpoch, _chainId);

    // Remove the chain ID
    vm.prank(arbitrator);
    eboRequestCreator.removeChain(_chainId);

    // Create a request without approving the chain ID
    vm.expectRevert(IEBORequestCreator.EBORequestCreator_ChainNotAdded.selector);
    vm.prank(_requester);
    eboRequestCreator.createRequest(_currentEpoch, _chainId);
  }
}
