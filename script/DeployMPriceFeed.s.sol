// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.26;

import { Script, console2 } from "../lib/forge-std/src/Script.sol";

import { NAVProxyMPriceFeed } from "../src/oracle/NAVProxyMPriceFeed.sol";

import { IPyth } from "@pythnetwork/pyth-sdk-solidity/IPyth.sol";

contract DeployMPriceFeedScript is Script {
    address internal constant _CHAINLINK_NAV_ORACLE = 0xC28198Df9aee1c4990994B35ff51eFA4C769e534; // Mainnet M^0 Chainlink NAV oracle
    IPyth public pyth;
    bytes32 public usdtbPriceId;

    function run() external {
        address deployer_ = vm.rememberKey(vm.envUint("PRIVATE_KEY"));

        pyth = IPyth(0x4305FB66699C3B2702D4d05CF36551390A4c69C6);
        usdtbPriceId = bytes32(0x967549f1ff4869f41cb354a7116b9e5a9a3091bebe0b2640eeed745ca1f7f90b);

        console2.log("Deployer:", deployer_);

        vm.startBroadcast(deployer_);

        address priceFeed = address(new NAVProxyMPriceFeed(address(pyth), usdtbPriceId));

        vm.stopBroadcast();

        console2.log("price feed:", priceFeed);
    }
}
