//SPDX-License-Identifier:MIT

pragma solidity^0.8.18;

import {Test} from "forge-std/Test.sol";
import {fundsLock} from "src/fundsLock.sol";
import {deployer} from "script/fundsLockDeploy.s.sol";
contract fundsLockTest is Test {

fundsLock FundsLock;
deployer Deployer; 
function setup() public {

}
}