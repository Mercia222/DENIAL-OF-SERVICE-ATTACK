// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingOfEther{
    address public king; //address of the current king
    uint public balance; // track balance of the highest amount of Ether sent 
    mapping(address => uint) public balances; //mapping to associate the address of the frontrunner to the amount 

    function claimThrone() external payable{
        require(msg.value > balance, "You need to pay more to become the king"); 

        balances[king] += balance; //update the previous frontrunner info ie. address and balance 

    //update of the new king info 
        balance = msg.value; 
        king = msg.sender; 
    }

//To prevent Denial of service attacks, one solution is to move the payment from a push to pull model 
//meaning allowing participants to withdraw the Ether refund instead of sending it

    function withdraw() public {

//to be allowed to withdraw, the former king must not be the current king who is msg.sender
//otherwise, revert the transaction because the current king cannot withdraw his Ether 
require(msg.sender != king, "Current king cannot withdraw!"); 

uint amount = balances[msg.sender]; //the amount equals to the balance of previous king
balances[msg.sender] = 0; //nullify the balance of msg.sender before the transfer 

(bool sent, ) = msg.sender.call{value: amount}(""); //confirm transfer of Ether with the call method 
require(sent, "Failed to send Ether"); //confirm if it was successful, if it fails then revert and display the error 

    }

}