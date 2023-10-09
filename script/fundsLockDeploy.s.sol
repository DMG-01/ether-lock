//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import {fundsLock} from "src/fundsLock.sol";


contract deployer is Script {

fundsLock FundsLock;
function run() public returns(fundsLock) {

    vm.startBroadcast();

      FundsLock = new fundsLock();
    vm.stopBroadcast();
    return (FundsLock);
}
}