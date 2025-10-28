// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {ERC1967Utils} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";

// we're using foundry-devops (https://github.com/Cyfrin/foundry-devops) to get the most recently deployed implementation
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {
    function run() external {
        // 1) we get the most recently deployed Proxy first...
        address mostRecentlyDeployedProxy = DevOpsTools
            .get_most_recent_deployment("ERC1967Proxy", block.chainid);

        // 2) ... then we deploy BoxV2 ...
        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();

        // 3) ... then we point to the new BoxV2 implementation by upgrading ...
        address proxy = upgradeBox(mostRecentlyDeployedProxy, address(boxV2));
    }

    function upgradeBox(
        address proxyAddress,
        address newImplementation
    ) public returns (address proxy) {
        vm.startBroadcast();

        // i) by doing this we give our proxyAddress the BoxV1 ABI -> and BoxV1 is UUPSUpgradeble (by inheritance) (n.d.r. cause remember that with UUPS the upgrade logic is inherited by/lives in the implementation)
        BoxV1 proxy = BoxV1(proxyAddress); // n.d.r. even if we do this "conversion" to get the interface

        // ii) upgradeToAndCall() simply tells to POINT the PROXY to the newImplementation address

        proxy.upgradeToAndCall(newImplementation, "");

        // n.d.r. we could also have ERC1967Utils library and, skipping i) and modifying ii) do simply
        /* 
            ERC1967Utils.upgradeToAndCall(newImplementation, "");
        */

        vm.stopBroadcast();
        return address(proxy);
    }
}
