//SPDX-License-Identifier:MIT

pragma solidity^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {fundsLock} from "src/fundsLock.sol";
import {deployer} from "script/fundsLockDeploy.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
contract fundsLockTest is Test {

address  constant USER1 = address(1);
address constant USER2 = address(2);
string constant PASSWORD = "aaa";
string constant WRONG_PASSWORD = "bbb";
uint256 constant USER_LOCK_FUND = 1 ether;
uint256 constant USER_STARTING_FUND = 100 ether;
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

function testFundUserIdIsGenerated() public {
   vm.deal(USER1,100);
   FundsLock.depositFunds{value: USER_STARTING_FUND}(60,PASSWORD);
  uint256 expectedUserId = 1;
  uint256  contractUserId = FundsLock.getCurrentUserId();
   assertEq(expectedUserId,contractUserId);
}

function testWithdrawFunctionWillRevertWithWrongPassword() public {
    vm.deal(USER1,USER_STARTING_FUND);
    
   //uint256 initialContractBalance = address(FundsLock).balance;
   vm.prank(USER1);
   FundsLock.depositFunds{value: USER_LOCK_FUND}(0,PASSWORD);
   vm.expectRevert();
   FundsLock.withdrawal(WRONG_PASSWORD,0);
   /*
   uint256  currentContractBalnce = address(FundsLock).balance;
   assertEq(initialContractBalance,currentContractBalnce);
   //console.log(initialContractBalance);
   //console.log(currentContractBalnce);
   */
}
function testWithdrawalWouldRevertWhenItsNotDue() public {
   vm.deal(USER1,USER_STARTING_FUND);
   vm.prank(USER1);
   FundsLock.depositFunds{value: USER_LOCK_FUND}(60,PASSWORD);
   vm.expectRevert();
   FundsLock.withdrawal(PASSWORD,0);
}
function testwouldRevertWhenADifferentUserWithdraws()public {
   vm.deal(USER1,USER_STARTING_FUND);
   vm.deal(USER2,USER_STARTING_FUND);
   vm.prank(USER1);
   FundsLock.depositFunds{value:USER_LOCK_FUND}(0,PASSWORD);
   vm.expectRevert();
   vm.prank(USER2);
   FundsLock.withdrawal(PASSWORD,0);
}
//function to stop other user from withdrawing
}