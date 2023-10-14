//SPDX-License-Identifier:MIT
// change all require statement



/*
adding the get userID 
after calling the deposit function the userId would be generated
it works with the userLocks array

create a counter
return the current counter number after the deposit function has been called
thats the userId
store  each userId
create a mapping to track the address to the userID's array

*/
pragma solidity^ 0.8.18;

contract fundsLock {
/* ERROR */
error invalidAmountPassed();
error noFundFound();
error invalidUserIdPassed();
error invalidUser();


/* STATE VARIABLE */
uint256 totalAmount;
uint256 userIdCounter;
address owner;

/* MODIFIER */
modifier onlyOwner() {
  require(msg.sender == owner,"YOU CANT CALL THIS FUNCTION");
  _;
}



/* CONSTRUCTOR */
constructor() {
  owner = msg.sender;
  userIdCounter = 0;
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
uint256[] userIds;
mapping(address  => userDetails[]) addressToDifferentLocks;
mapping (address => userDetails) addressToUserDetails;
mapping (address => uint256[]) addressToUserIds;

//function to set depositfund with time
// deposits fund by assigning values to the user details then creating a new userDetail and pushing it into the array
// PS: I MAY NEED TO DO THE MAPPING OF ADDRESS TO THE ARRAY
function depositFunds(uint256 _timelock, string memory _password) payable public  returns(uint256){

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
//userIdCounter++;
uint256 newUserId = userIdCounter++;
//addressToUserIds[msg.sender] = userIds.push(newUserId); WORK HERE
userIds.push(newUserId);
return (newUserId - 1);

}

// function to withdraw 
// uses an index to get the specific fund that the user wants to withdraw
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

function getUserDepositedAmount( uint256 index_) public view returns(uint256) {
  if((index_ > userLocks.length) || (index_ < 0)) {
    revert invalidUserIdPassed();
  }
  if(msg.sender != userLocks[index_].user) {
    revert invalidUser();
  }
  return( userLocks[index_].amount);
}
function allUserDetails(uint256 index_) public view returns(userDetails memory) {
  if(msg.sender != userLocks[index_].user) {
    revert invalidUser();
  }
  return( userLocks[index_]);
}

function getAllUserFundId() public view returns(uint256[] memory) {
    return addressToUserIds[msg.sender];
}
function getCurrentUserId() public view returns(uint256) {
   return userIdCounter - 0;
}

function getCurrentUser() public view returns(address) {
  return(msg.sender);
}
}
//give user a number that would be used to withdraw
// make the password harder ---- removed too expensive

// function to revert error when withdrawing from an aready withdrawn account  ---- DONEE
