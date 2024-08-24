# CrowdFunding Smart Contract

## Overview

The `CrowdFunding` contract is a decentralized crowdfunding platform that allows users to create campaigns, donate to campaigns, and manage funds. The contract is written in Solidity and is designed to be deployed on Ethereum-compatible blockchains.

## Features

- **Create Campaigns:** Users can create new crowdfunding campaigns with a title, description, goal amount, and duration.
- **Donate to Campaigns:** Users can donate funds to specific campaigns.
- **End Campaigns:** Campaigns can be ended once the deadline is reached, and funds are transferred to the campaign's benefactor.
- **Withdraw Funds:** The owner of the contract can withdraw any leftover funds after a campaign ends.

## Contract Structure

### State Variables

- `address public owner`: The address of the contract owner.
- `uint public campaignCount`: The count of active campaigns.
- `mapping(uint => Campaign) public campaigns`: Mapping of campaign IDs to Campaign structures.

### Structs

- `struct Campaign`: Defines the structure of a campaign.
  - `string title`: The title of the campaign.
  - `string description`: The description of the campaign.
  - `address payable benefactor`: The address that will receive the funds if the campaign is successful.
  - `uint goal`: The funding goal of the campaign.
  - `uint deadline`: The deadline timestamp for the campaign.
  - `uint amountRaised`: The amount of funds raised so far.
  - `bool ended`: Status of whether the campaign has ended.

### Events

- `event CampaignCreated(uint campaignId, string title, string description, address benefactor, uint goal, uint deadline)`: Emitted when a new campaign is created.
- `event DonationReceived(uint campaignId, address donor, uint amount)`: Emitted when a donation is received.
- `event CampaignEnded(uint campaignId, address benefactor, uint amountRaised)`: Emitted when a campaign ends.

### Functions

- `constructor()`: Initializes the contract with the owner's address.
- `createNewCampaign(string memory _title, string memory _description, address payable _benefactor, uint _goal, uint _duration)`: Allows users to create a new campaign.
- `dononateToSpecificCampaign(uint _campaignId) public payable`: Allows users to donate to a specific campaign.
- `checkAndEndCampaign(uint _campaignId) public`: Checks if the campaign deadline has passed and ends the campaign if needed.
- `_endCampaign(uint _campaignId) internal`: Ends a campaign and transfers the raised funds to the benefactor.
- `withdrawLeftoverFunds() public onlyOwner`: Allows the owner to withdraw any leftover funds from the contract.

### Modifiers

- `modifier onlyOwner()`: Restricts function access to the contract owner.

## Deployment

To deploy the `CrowdFunding` contract:

1. Compile the contract using a Solidity compiler compatible with version `^0.8.24`.
2. Deploy the contract using your preferred Ethereum development environment (e.g., Remix, Hardhat).
