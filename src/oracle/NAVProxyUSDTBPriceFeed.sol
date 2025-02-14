// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.26;

import { IPyth } from "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import { PythStructs } from "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

/**
 * @title  NAV Proxy USDTB Chainlink Compatible Price Feed
 * @notice A proxy contract that retrieves NAV (Net Asset Value) data from an external oracle,
 *         converts it to a USDTB price based on a specified threshold, and is compatible with
 *         the Chainlink AggregatorV3Interface.
 * @dev This contract is a modified version of the PythAggregatorV3 contract from the Pyth Network.
 * @author Pyth Labs
 * @author modified by Usual Labs
 */
contract NAVProxyUSDTBPriceFeed {

    /// @notice NAV price threshold that defines 1$ USDTB price.
    int256 public constant NAV_POSITIVE_THRESHOLD = 1e8;

    /// @notice The Pyth price ID for the USDTB NAV.
    bytes32 public priceId;

    /// @notice The Pyth price feed.
    IPyth public pyth;

    /// @notice The number of decimals used in price feed output.
    uint8 public constant PRICE_FEED_DECIMALS = 8;

    constructor(address _pyth, bytes32 _priceId) {
        priceId = _priceId;
        pyth = IPyth(_pyth);
    }

    // Wrapper function to update the underlying Pyth price feeds. Not part of the AggregatorV3 interface but useful.
    function updateFeeds(bytes[] calldata priceUpdateData) public payable {
        // Update the prices to the latest available values and pay the required fee for it. The `priceUpdateData` data
        // should be retrieved from our off-chain Price Service API using the `pyth-evm-js` package.
        // See section "How Pyth Works on EVM Chains" below for more information.
        uint fee = pyth.getUpdateFee(priceUpdateData);
        pyth.updatePriceFeeds{value: fee}(priceUpdateData);

        // refund remaining eth
        payable(msg.sender).call{value: address(this).balance}("");
    }

    function decimals() public view virtual returns (uint8) {
        return PRICE_FEED_DECIMALS;
    }

    function description() public pure returns (string memory) {
        return "USDTB by Ethena / USD";
    }

    function version() public pure returns (uint256) {
        return 1;
    }

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        PythStructs.Price memory price = pyth.getPriceUnsafe(priceId);
        return (
            _roundId,
            _getPriceFromNAV(int256(price.price)),
            price.publishTime,
            price.publishTime,
            _roundId
        );
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        PythStructs.Price memory price = pyth.getPriceUnsafe(priceId);
        roundId = uint80(price.publishTime);
        return (
            roundId,
            _getPriceFromNAV(int256(price.price)),
            price.publishTime,
            price.publishTime,
            roundId
        );
    }

    /**
     * @dev Converts NAV price to USDTB price based on a predefined sensitivity threshold.
     * @param  answer The NAV price to convert.
     * @return        The USDTB price.
     */
    function _getPriceFromNAV(int256 answer) internal view returns (int256) {
        PythStructs.Price memory price = pyth.getPriceUnsafe(priceId);
        uint8 oracleDecimals = uint8(-1 * int8(price.expo));

        // Scale the answer to the PRICE_FEED_DECIMALS for the valid comparison.
        int256 scaledAnswer = (answer * int256(10 ** PRICE_FEED_DECIMALS)) / int256(10 ** oracleDecimals);

        return scaledAnswer >= NAV_POSITIVE_THRESHOLD ? NAV_POSITIVE_THRESHOLD : scaledAnswer;
    }
}
