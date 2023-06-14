// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DisputeResolution {
    enum DisputeStatus { Pending, Resolved }
    
    struct Dispute {
        address submitter;
        address respondent;
        string description;
        DisputeStatus status;
    }
    
    mapping(uint256 => Dispute) public disputes;
    uint256 public disputeCount;
    
    event DisputeSubmitted(uint256 indexed id, address indexed submitter, address indexed respondent, string description);
    event DisputeResolved(uint256 indexed id, DisputeStatus status);
    
    modifier onlyParties(uint256 _id) {
        require(disputes[_id].submitter == msg.sender || disputes[_id].respondent == msg.sender, "Unauthorized");
        _;
    }
    
    function submitDispute(address _respondent, string memory _description) public {
        disputeCount++;
        disputes[disputeCount] = Dispute(msg.sender, _respondent, _description, DisputeStatus.Pending);
        
        emit DisputeSubmitted(disputeCount, msg.sender, _respondent, _description);
    }
    
    function resolveDispute(uint256 _id, DisputeStatus _status) public onlyParties(_id) {
        require(disputes[_id].status == DisputeStatus.Pending, "Dispute is not pending");
        
        disputes[_id].status = _status;
        
        emit DisputeResolved(_id, _status);
    }
}
