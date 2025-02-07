// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IOracle} from '@defi-wonderland/prophet-core/solidity/interfaces/IOracle.sol';
import {IArbitrator} from '@defi-wonderland/prophet-modules/solidity/interfaces/IArbitrator.sol';
import {IArbitratorModule} from
  '@defi-wonderland/prophet-modules/solidity/interfaces/modules/resolution/IArbitratorModule.sol';

import {IArbitrable} from 'interfaces/IArbitrable.sol';

/**
 * @title CouncilArbitrator
 * @notice Resolves disputes by arbitration by The Graph
 */
interface ICouncilArbitrator is IArbitrator {
  /*///////////////////////////////////////////////////////////////
                              STRUCTS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Parameters of the resolution as stored in the contract
   * @param request The request data
   * @param response The response data
   * @param dispute The dispute data
   */
  struct ResolutionParameters {
    IOracle.Request request;
    IOracle.Response response;
    IOracle.Dispute dispute;
  }

  /*///////////////////////////////////////////////////////////////
                              EVENTS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Emitted when a resolution is started by the Arbitrator Module
   * @param _disputeId The ID of the dispute that the resolution was started for
   * @param _request The request data
   * @param _response The response data
   * @param _dispute The dispute data
   */
  event ResolutionStarted(
    bytes32 indexed _disputeId, IOracle.Request _request, IOracle.Response _response, IOracle.Dispute _dispute
  );

  /**
   * @notice Emitted when a dispute is arbitrated by The Graph's Arbitrator
   * @param _disputeId The ID of the dispute that was arbitrated
   * @param _award The final result of the resolution
   */
  event DisputeArbitrated(bytes32 indexed _disputeId, IOracle.DisputeStatus _award);

  /*///////////////////////////////////////////////////////////////
                              ERRORS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Thrown when the caller is not the Arbitrator Module
   */
  error CouncilArbitrator_OnlyArbitratorModule();

  /**
   * @notice Thrown when trying to arbitrate a dispute with no pending resolution
   */
  error CouncilArbitrator_InvalidDispute();

  /**
   * @notice Thrown when trying to arbitrate a dispute with an invalid award
   */
  error CouncilArbitrator_InvalidAward();

  /**
   * @notice Thrown when trying to arbitrate a dispute that is already arbitrated
   */
  error CouncilArbitrator_DisputeAlreadyArbitrated();

  /*///////////////////////////////////////////////////////////////
                              VARIABLES
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Returns the address of the Oracle
   * @return _oracle The address of the Oracle
   */
  function ORACLE() external view returns (IOracle _oracle);

  /**
   * @notice Returns the address of the Arbitrator Module
   * @return _arbitratorModule The address of the Arbitrator Module
   */
  function ARBITRATOR_MODULE() external view returns (IArbitratorModule _arbitratorModule);

  /**
   * @notice Returns the address of the arbitrable contract
   * @return _ARBITRABLE The address of the arbitrable contract
   */
  function ARBITRABLE() external view returns (IArbitrable _ARBITRABLE);

  /**
   * @notice Returns the resolution data for a dispute
   * @param _disputeId The ID of the dispute
   * @return _request The request data
   * @return _response The response data
   * @return _dispute The dispute data
   */
  function resolutions(bytes32 _disputeId)
    external
    view
    returns (IOracle.Request memory _request, IOracle.Response memory _response, IOracle.Dispute memory _dispute);

  /**
   * @notice Returns the resolution parameters for a dispute
   * @param _disputeId The ID of the dispute
   * @return _resolutionParams The resolution parameters
   */
  function getResolution(bytes32 _disputeId) external view returns (ResolutionParameters memory _resolutionParams);

  /*///////////////////////////////////////////////////////////////
                              LOGIC
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Publishes the arbitration award, resolves a dispute and, if applicable, finalizes a request
   * @dev Callable only by The Graph's Arbitrator
   * @param _disputeId The ID of the dispute
   * @param _award The result of the resolution for the dispute
   */
  function arbitrateDispute(bytes32 _disputeId, IOracle.DisputeStatus _award) external;
}
