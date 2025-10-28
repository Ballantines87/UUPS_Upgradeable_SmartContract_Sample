// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

import {ERC1967Utils} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract DeplotAndUpgradeTest is Test {
    DeployBox deployer;
    UpgradeBox upgrader;

    address proxy;
    BoxV1 boxV1;
    address OWNER = makeAddr("owner");

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); // ... and right now the proxy points to BoxV1
    }

    function testUpgrade() external {
        BoxV2 boxV2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(boxV2));
        uint256 expectedVersionValue = 2;
        assertEq(expectedVersionValue, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }

    function testProxyStartsAsBoxV1() external {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7); // it should revert because this setNumber() function doesn't exist/we didn't create it in BoxV1
    }
}
