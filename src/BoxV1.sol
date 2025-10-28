// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/* UUPSUpgradeable is an upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing `UUPSUpgradeable` with a custom implementation of upgrades.
 */

// N.B: if we check within UUPSUpgradeable.sol -> we can see the main function we'll need to leverage upgradeToAndCall() -> This will allow us to upgrade the implementation address of our protocol. We'll need to inherit UUPSUpgradeable with BoxV1.
import {UUPSUpgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

// N.B. we need Initializable (which contains some initialize() function
// -> that's because a Proxy 1. holds the storage variables for the implementation -> 2. because they borrow the functions (aka the logic) from the implementation and executes them in their context (hence why they store the variables in their state 3. BUT don't have a constructor -> so you need to call some external initialize() function (n.d.r. which is provided by OpenZeppelin's Initializable.sol)

// so the flow is like this
// proxy -> deploy implementation -> call some "initializer" function.
// (and the "initializer" function is essentially your constructor, except for the fact that it's gonna be called *IN* the proxy)

import {Initializable} from "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

//
import {OwnableUpgradeable} from "../lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract BoxV1 is UUPSUpgradeable, Initializable, OwnableUpgradeable {
    uint256 internal number;

    // this "_disableInitializers()" (from Intializable.sol) function does NOT let ANY FUTURE initialization happen / does NOT let calling ANY FUTURE initializers functions -> therefore locking the implementation contract designed to be called through proxies
    // N.B. basically the constructor with "disables" the constructor, so that storage variables are kept in the proxy

    /// @custom:oz-upgrades-unsafe-allow constructor // -> this line is for some linters which notice that we're using a constructor inside an upgradeable contract and they tell us not to do that -> with this comment we just tell them "hey, just let it happen"
    constructor() {
        _disableInitializers();
    }

    // Because storage for a proxied protocol is stored in the proxy -> any initial set up needs to be done AFTER an implementation contract's deployment. This is handled through this initializer functionality -> so we do add the initialize() function here (n.d.r. to initialize the proxy storage values soon after deploying the new implementation contract) -> and inside it we add whatever (n.d.r. storage variables) we wanna initialize to (after deploying the implementation contract of course)
    // N.B.  initializer is a modifier defined inside Intializable.sol, which basically ensures that you can ONLY INITIALIZE ONE TIME
    function initialize() public initializer {
        // N.B. notice that if we want our Proxy to have an owner, we can't set it - e.g., owner = msg.sender - inside the constructor, like we normally do with a Ownable contract -> INSTEAD, we need to put it INSIDE the initialize() function -> by using the __Ownable_init() function, provided by Openzeppelin's OwnableUpgradeable.sol
        // -> so this sets the owner to msg.sender (same as setting "owner = msg.sender")
        __Ownable_init(msg.sender); // the double underscore __ is, by convention, to say it's an initializer function
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    // The _authorizeUpgrade() comes from UUPSUpgradeable.sol -> and it's a function that 1) we need (virtual in UUPSUpgradeable -> inherited by BoxV1 so we need to override and define) and 2) so we'll need to define within our protocol with the logic to denote how an upgrade is authorized, perhaps limitations on who can upgrade with a check on msg.sender, for example
    // N.B. we haven't added it yet, but we should add an onlyOwner modifier here so that upgrades are authorized only by the owner
    function _authorizeUpgrade(address newImplementation) internal override {}
}
