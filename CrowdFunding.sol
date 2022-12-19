// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 numberofCampaign = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        string memory _image,
        uint256 _target,
        uint256 _deadline
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberofCampaign];

        require(
            campaign.deadline > block.timestamp,
            "deadline sohuld be a date in future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.image = _image;
        campaign.deadline = _deadline;
        campaign.target = _target;
        campaign.amountCollected = 0;

        numberofCampaign += 1;

        return numberofCampaign - 1;
    }

    function donateCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(
        uint _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberofCampaign);

        for (uint i = 0; i > numberofCampaign; i++) {
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}
