pragma solidity 0.7.4;
// SPDX-License-Identifier: MIT

contract DistributeFunding {
    mapping(address => Shareholder) shareholders;
    address payable[] shareholdersAddresses;
    address owner;
    uint sum = 0;
    uint sharedPercentage = 0;

    event campaignReceived(uint _sum);

    struct Shareholder {
        string name;
        uint percentage;
    }

    constructor() {
        owner = msg.sender;
    }

    function addShareholder (
        address payable _shareholder,	
        string memory _name,
        uint _percentage
    ) public {
        require(owner == msg.sender, "You are not the owner");
        require(_percentage <= 100, "This value is not accepted");
        require(
            sharedPercentage + _percentage <= 100,
            "The shared percentage increases the total above 100"
        );

        shareholders[_shareholder] = Shareholder({
            name: _name,
            percentage: _percentage
        });
        shareholdersAddresses.push(_shareholder);
        sharedPercentage += _percentage;
    }

    receive() external payable {
        sum = msg.value;
        emit campaignReceived(sum);
    }
    
    function distributeFunds() public {
        require(sum > 0, "Not enough funds");
        require(owner == msg.sender, "You are not the owner");
        require(sharedPercentage == 100, "Total funds < 100");
        for (uint i = 0; i < shareholdersAddresses.length; i++) {
            shareholdersAddresses[i].transfer(
                (shareholders[shareholdersAddresses[i]].percentage * sum) / 100
            );
        }
    }
}
