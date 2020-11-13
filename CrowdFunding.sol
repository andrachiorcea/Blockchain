pragma solidity 0.7.4;
// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
import "./DistributeFunding.sol";

contract CrowdFunding {
    uint fundingGoal;
    uint currentFunds;
    address public owner;

    mapping(address => Contributor) contributors;
    
    DistributeFunding distributeFunding;

    struct Contributor {
        string name;
        address senderAddress; 
        uint amount;
    }

    event newDonation(Contributor _contributor);
    event donationWithdrawn(address _sender, uint _amount);
    event checkStatus(uint _currentFunds, string _message, uint _toBeDeposed);
    event campaignEnded();

    constructor() {
        owner = msg.sender;
        currentFunds = 0;
    }

    function donate(string memory _name)
        public
        payable
    {
        require(currentFunds <= fundingGoal, "The campaign ended");
        require(msg.value > 0, "The donated sum should be greather that 0");

        currentFunds += msg.value;

        Contributor memory contributor = contributors[msg.sender];
        if (contributor.amount == 0) {
            contributor = Contributor({
                name: _name,
                senderAddress: msg.sender,
                amount: msg.value
            });
        } else {
            contributor.amount += msg.value;
        }
        contributors[msg.sender] = contributor;
        emit newDonation(contributor);
        if (currentFunds > fundingGoal) {
            emit campaignEnded();
        }
    }

    function withdraw(uint _amount) public {
        Contributor memory contributor = contributors[msg.sender];

        require(
            contributor.amount > 0,
            "You are not part of our list of contributors."
        );
        require(_amount < contributor.amount, "You cannot retract");
        require(currentFunds < fundingGoal, "Our campaign has ended.");
        contributor.amount -= _amount;
        if (contributor.amount == 0) {
            delete contributors[msg.sender];
        }
        msg.sender.transfer(_amount);
        currentFunds -= _amount;
        emit donationWithdrawn(msg.sender, _amount);
    }

    function campaignStatus() public {
        if(fundingGoal == 0) {
            emit checkStatus(0, "Please set a fundingGoal",0);
        }
        else if (currentFunds < fundingGoal) {
            uint _toBeDeposed = fundingGoal-currentFunds;
            emit checkStatus(currentFunds, "Goal not reached", _toBeDeposed);
        } else {
            emit checkStatus(
                currentFunds,
                "We have the money. Go shopping ^_^",
                0
            );
        }
    }

    function setFundingGoal(uint _fundingGoal) public {
        require(owner == msg.sender, "The setter needs to be the owner");
        fundingGoal = _fundingGoal;
    }

    function sentToDistribute(address payable _distributeFunding) public {
        require(owner == msg.sender, "The sender neds to be the owner of the contract");
        require(currentFunds >= fundingGoal, "The campaign has not ended.");
        (bool success,  ) = _distributeFunding.call{value: currentFunds}("");
        require(success, "Failed to transfer the funds, aborting.");
        currentFunds = 0;
    }
}
