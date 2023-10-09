//SPDX-License-Identifier:MIT
pragma solidity^ 0.8.18;

contract fundsLock {
/* ERROR */
error invalidAmountPassed();
error noFundFound();


/* STATE VARIABLE */
uint256 totalAmount;
address owner;

/* MODIFIER */
modifier onlyOwner() {
  require(msg.sender == owner,"YOU CANT CALL THIS FUNCTION");
  _;
}



/* CONSTRUCTOR */
constructor() {
  owner = msg.sender;
}

// a struct that contains all the details of every 'FUND' that is locked
struct userDetails {
  uint256 timelock;
  string password;
  uint256 amount;
  uint256 timeDeposited;
  uint256 ripeTime;
  address user;
  
}
// an array that is used to store all the different times the contract is funded
// ps: i'm currently suggesting a mapping of user to the amount funded
// consist of two mappings one is user address to an array(funds of the specific user)
// and the other is a mapping of user to the fund details

userDetails[]  userLocks;
mapping(address => userDetails[]) addressToDifferentLocks;
mapping (address => userDetails) addressToUserDetails;

//function to set depositfund with time
// deposits fund by assigning values to the user details then creating a new userDetail and pushing it into the array
// PS: I MAY NEED TO DO THE MAPPING OF ADDRESS TO THE ARRAY
function depositFunds(uint256 _timelock, string memory _password) payable public {

if ((msg.value == 0) || (msg.value < 0)) {
 revert invalidAmountPassed();
}
addressToUserDetails[msg.sender].timelock = _timelock;
addressToUserDetails[msg.sender].password = _password;
addressToUserDetails[msg.sender].amount = msg.value;
addressToUserDetails[msg.sender].timeDeposited = block.timestamp;
addressToUserDetails[msg.sender].ripeTime = block.timestamp + _timelock;
addressToUserDetails[msg.sender].user = msg.sender;
totalAmount += msg.value;

userDetails memory UserDetails = userDetails(
  _timelock,
  _password,
  msg.value,
  block.timestamp,
  block.timestamp + _timelock,
  msg.sender
);
userLocks.push(UserDetails);
}

// function to withdraw 
// uses an index to get the specific fund thhat the user wants to withdraw
//if the requirement is met

function withdrawal(string memory __password, uint256 _index) public payable {
  require(block.timestamp > userLocks[_index].ripeTime,"WITHDRAWAL CAN'T BE MADE YET");
require(keccak256(bytes(__password)) == keccak256(bytes(userLocks[_index].password)), "INVALID PASSWORD");
  require(msg.sender == userLocks[_index].user, "INVALID USER");
  require(_index < userLocks.length,"INVALID INDEX PASSED");
  
  
  if(userLocks[_index].amount == 0) {
    revert noFundFound();
  }
 
     uint256 userBalance = userLocks[_index].amount;
    totalAmount -= userLocks[_index].amount;
    userLocks[_index].amount = 0;
   payable(msg.sender).transfer(userBalance);
  
}

//GETTER FUNCTION//
function getTotalAmount() onlyOwner public view returns(uint256) {
 return totalAmount;
}

function getUserAddress() public view returns(address) {
  return msg.sender;
}

function getUserTimeLeft() public view returns(uint256) {
  if(block.timestamp < addressToUserDetails[msg.sender].ripeTime){
  return(addressToUserDetails[msg.sender].ripeTime - block.timestamp);
}
else {
  return 0;
}
}

function getUserDepositedAmount() public view returns(uint256) {
  return(addressToUserDetails[msg.sender].amount);
}
function allUserDetails(uint256 index_) public view returns(userDetails memory) {
  require(msg.sender == userLocks[index_].user,"YOU CAN CALL THIS FUNCTION WITH THIS INDEX");
  return( userLocks[index_]);
}

}
//give user a number that would be used to withdraw
// make the password harder ---- removed too expensive

// function to revert error when withdrawing from an aready withdrawn account  ---- DONEE
