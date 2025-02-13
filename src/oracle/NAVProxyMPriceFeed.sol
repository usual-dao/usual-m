// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.26;

import { PythAggregatorV3 } from "@pythnetwork/pyth-sdk-solidity/PythAggregatorV3.sol";

/**
 * @title  NAV Proxy M Chainlink Compatible Price Feed
 * @notice A proxy contract that retrieves NAV (Net Asset Value) data from an external oracle,
 *         converts it to a M price based on a specified threshold, and is compatible with
 *         the Chainlink AggregatorV3Interface.
 * @author M^0 Labs
 */
contract NAVProxyMPriceFeed is PythAggregatorV3 {
    constructor(address pyth_, bytes32 priceId_) PythAggregatorV3(pyth_, priceId_) {}
}
