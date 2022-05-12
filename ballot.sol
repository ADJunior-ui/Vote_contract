// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

contract Ballot {

  
    //candidate Information
    struct Proposal {
        uint8 voteCount;
        string name;
    }                      
    Proposal[] public proposalList;    

    //voter information                                   
    struct Voter {
        uint8 vote;         
        uint8 weight;      
        bool voted;        
    }


    //access to voter information
    mapping(address => Voter) public voterList;
    


    address public chairPerson;

    //specify the number of candidates by chair Person
    constructor(uint8 _proposalCount) {

        //adrress deployer //chairPerson
        chairPerson = msg.sender;

       //weight of votes chair Person
        voterList[chairPerson].weight = 2;

       //add candidates to the array proposalList
        for(uint8 i=0; i < _proposalCount; i++) {
            proposalList.push( Proposal({voteCount:0, name:""}));
        }
    }

    //registration conditions
    modifier conditions_register(address _voterAdr){
     //registration by chair Person only   
        require(msg.sender == chairPerson, "Only Chairperson Can Register Others!");

       //the owner can not re-register
        require(_voterAdr != chairPerson, "Chairperson Can't Register Again!");

       //the registrant must not have already voted
        require(voterList[_voterAdr].voted == false, "Voter Already Voted!");
        _;
    }

    //register to vote
    function register(address _voterAdr) public  conditions_register( _voterAdr){

        //weight of votes Registrant
        voterList[_voterAdr].weight = 1;
    }

    //voting conditions
    modifier conditions_vote(uint8 _proposalID){
         
         //the selected candidate must be present
        require(_proposalID < proposalList.length, "Invalid ProposalID!");

        //the voter must have already registered
        require(voterList[msg.sender].weight > 0, "You don't Registered Yet!");

        //the voter must have already voted
        require(voterList[msg.sender].voted == false, "Voter Already Voted!");
        _;
    }

    //voting 
    function vote(uint8 _proposalID) public conditions_vote(_proposalID) {
     
        //voter vote
        voterList[msg.sender].vote = _proposalID;
        //the voter has voted
        voterList[msg.sender].voted = true;

        //add the voter vote to the candidate according to the weight of the vote
        proposalList[_proposalID].voteCount += voterList[msg.sender].weight;
    }


    //identify the winner
    function count() public view returns(uint8 winnerPropID, uint8 winnerPropVoteCount) {
        
        //Number of participants
        uint proposalCount = proposalList.length;

        for(uint8 i=0; i<proposalCount; i++) {

            //Select the winner according to the number of votes
            if( proposalList[i].voteCount >  winnerPropVoteCount) {
                winnerPropID = i;                                     
                winnerPropVoteCount =  proposalList[i].voteCount;       
            }
        }

        
    }
  

}





