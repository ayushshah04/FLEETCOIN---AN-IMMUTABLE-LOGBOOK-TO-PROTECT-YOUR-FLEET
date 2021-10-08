pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";

contract TRUXToken is ERC20, ERC20Detailed, ERC20Mintable {
    
    mapping(address => uint) public tokenDistribution;
    
    constructor(
        string memory name,
        string memory symbol
   //     uint initial_supply
    )
        ERC20Detailed(name, symbol, 18)
        public
    {
        // mint inside rewardToken function 
    }
    
    function rewardToken(address wallet, uint quantity) public {
        mint(wallet, quantity);
        
        tokenDistribution[wallet] += quantity;
        
        }

    }

