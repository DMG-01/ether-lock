//SPDX-License-Identifier:MIT

pragma solidity^0.8.18;

import {Test} from "forge-std/Test.sol";
import {fundsLock} from "src/fundsLock.sol";
import {deployer} from "script/fundsLockDeploy.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
contract fundsLockTest is Test {

address  constant USER1 = address(1);
string constant PASSWORD = "aaa";
uint256 constant USER_STARTING_FUND = 10 ether;
fundsLock FundsLock;


function setUp() public {
deployer Deployer = new deployer();
 FundsLock = Deployer.run();
 
}

function testDepositFundsWouldRevertWhenAmountIsZero() public {
vm.deal(USER1,0);
vm.expectRevert();
FundsLock.depositFunds{value : 0}(60,PASSWORD);
}

function testDepositFundsWorks() public {
vm.deal(USER1,100);
FundsLock.depositFunds{value : USER_STARTING_FUND}(60,PASSWORD);
   uint256 contractBalance = address(FundsLock).balance;
   assertEq(contractBalance, USER_STARTING_FUND);
}

}