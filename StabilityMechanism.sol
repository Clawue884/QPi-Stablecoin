// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract StabilityMechanism {
    uint256 public constant TARGET_PRICE = 314159; // $314.159
    uint256 public totalSupply;
    mapping(address => uint256) public balances;

    event SupplyAdjusted(uint256 newSupply, uint256 price);

    function adjustSupply(uint256 currentPrice) public {
        require(currentPrice > 0, "Invalid price");

        if (currentPrice > TARGET_PRICE) {
            uint256 excessSupply = (currentPrice - TARGET_PRICE) * totalSupply / TARGET_PRICE;
            totalSupply -= excessSupply;
        } else {
            uint256 deficitSupply = (TARGET_PRICE - currentPrice) * totalSupply / TARGET_PRICE;
            totalSupply += deficitSupply;
        }

        emit SupplyAdjusted(totalSupply, currentPrice);
    }

    function mint(address recipient, uint256 amount) public {
        totalSupply += amount;
        balances[recipient] += amount;
    }

    function burn(address from, uint256 amount) public {
        require(balances[from] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balances[from] -= amount;
    }
}
