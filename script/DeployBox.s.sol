// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "../lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    address proxy;

    function run() external returns (address) {
        vm.startBroadcast();
        proxy = deployBox();
        vm.stopBroadcast();
        return proxy;
    }

    function deployBox() public returns (address) {
        // 1) this is gonna be our implementation (Logic) -> this is where our proxy is gonna point to delegateCall(), to borrow those functions
        BoxV1 box = new BoxV1();

        // 2) now we need to get a proxy on top of this -> and the proxy we're gonna use is the ERC-1967 proxy -> that's the proxy we're gonna use to point to our implementation (aka BoxV1 in our example), which has all this upgradeable logic in it

        // N.B. the 1st argument to the constructor is the address of the implementation, the 2nd argument is ANY "initializer stuff/data" that you wanna pass to the initializer (n.d.r. we're not gonna have any initializer stuff in our demo, so we're just gonna put "")
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");
        return address(proxy);
    }
}
