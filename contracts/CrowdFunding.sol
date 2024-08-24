// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract ReentrancyGuard {
    bool private _notEntered;

    constructor() {
        _notEntered = true;
    }

    modifier nonReentrant() {
        require(_notEntered, "ReentrancyGuard: reentrant call");
        _notEntered = false;
        _;
        _notEntered = true;
    }
}


contract CrowdFunding is ReentrancyGuard {
    // the state variables
    address public owner;
    uint public campaignCount;

    // the structure of the campaign
    struct Campaign {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool ended;
    }

    // the mapping of the campaigns
    mapping(uint => Campaign) public campaigns;

    // Events
    event CampaignCreated(
        uint campaignId,
        string title,
        string description,
        address benefactor,
        uint goal,
        uint deadline
    );
    event DonationReceived(uint campaignId, address donor, uint amount);
    event CampaignEnded(uint campaignId, address benefactor, uint amountRaised);

    // the constructor
    constructor() {
        owner = msg.sender;
        campaignCount = 0;
    }

    // the function to create a new campaign
    function createNewCampaign( 
        string memory _title,
        string memory _description,
        address payable _benefactor,
        uint _goal,
        uint _duration
        ) public {
            require(_goal > 0, "Goal must be greater than 0");

            uint deadline = block.timestamp + _duration;

            // creating a new campaign
            campaigns[campaignCount] = Campaign(
                title: _title,
                description: _description,
                benefactor: _benefactor,
                goal: _goal,
                deadline,
                amountRaised: 0,
                ended: false
            );

            // incrementing when the campaign is created successfully
            campaignCount++;

            // emitting the event
            emit CampaignCreated(campaignCount, _title, _description, _benefactor, _goal, deadline);
        }

       // the function to donate to a campaign
       function dononateToSpecificCampaign(uint _campaignId) public payable {
          Campaign storage campaign = campaigns[_campaignId];

          require(block.timestamp < campaign.deadline, "Campaign has already ended");
          require(!campaign.ended, "Campaign has ended");
          require(msg.value > 0, "Donation amount must be greater than zero");

          campaign.amountRaised += msg.value;

          emit DonationReceived(_campaignId, msg.sender, msg.value);
       }

        // the function to end a campaign and transfer the funds to the benefactor
        function _endCampaign(uint _campaignId) internal nonReentrant {
            Campaign storage campaign = campaigns[_campaignId];

            require(block.timestamp >= campaign.deadline, "Campaign is still active");
            require(!campaign.ended, "Campaign already ended");

            campaign.ended = true;

            campaign.benefactor.transfer(campaign.amountRaised);

            emit CampaignEnded(_campaignId, campaign.benefactor, campaign.amountRaised);
        }

        // Function to check and end a campaign if the deadline is reached
        function checkAndEndCampaign(uint _campaignId) public {
            Campaign storage campaign = campaigns[_campaignId];

            if (block.timestamp >= campaign.deadline && !campaign.ended) {
                _endCampaign(_campaignId);
            }
        }

        // Modifier to restrict access to owner only
        modifier onlyOwner() {
           require(msg.sender == owner, "Only the owner can execute this");
           _;
       }

        // Function for owner to withdraw leftover funds (if any)
       function withdrawLeftoverFunds() public onlyOwner {
            require(address(this).balance > 0, "No leftover funds available");
            payable(owner).transfer(address(this).balance);
       }
}
