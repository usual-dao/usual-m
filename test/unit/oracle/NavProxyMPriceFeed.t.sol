// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import { Test, console2 } from "../../../lib/forge-std/src/Test.sol";

import { MockPyth } from "../../utils/Mocks.sol";

import { AggregatorV3Interface } from "../../../src/oracle/AggregatorV3Interface.sol";
import { NAVProxyMPriceFeed } from "../../../src/oracle/NAVProxyMPriceFeed.sol";

contract NAVProxyMPriceFeedUnitTests is Test {
    NAVProxyMPriceFeed public priceFeed;
    MockPyth public mockPyth;

    function setUp() public {
        mockPyth = new MockPyth();
        priceFeed = new NAVProxyMPriceFeed(address(mockPyth), bytes32(0));
    }

    function test_constructor() external {
        assertEq(priceFeed.priceId(), bytes32(0));
        assertEq(priceFeed.version(), 1);
        assertEq(priceFeed.decimals(), 10);
    }

    function test_updateFeeds() external {
        mockPyth.setRoundData(1e10, block.timestamp);
        (uint80 roundId, int256 price, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();
        assertEq(roundId, block.timestamp);
        assertEq(price, 1e10);
        assertEq(startedAt, block.timestamp);
        assertEq(updatedAt, block.timestamp);
        assertEq(answeredInRound, block.timestamp);
    }
}
