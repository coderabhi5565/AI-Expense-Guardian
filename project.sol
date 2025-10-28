// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AI Expense Guardian
 * @dev A smart contract that helps users track, categorize, and limit their expenses.
 *      It’s designed as the blockchain component of an AI-driven expense management system.
 */
contract AIExpenseGuardian {
    address public owner;

    struct Expense {
        uint256 id;
        string category;
        uint256 amount;
        string description;
        uint256 timestamp;
    }

    uint256 private nextExpenseId;
    mapping(address => Expense[]) private userExpenses;
    mapping(address => uint256) public spendingLimit;

    event ExpenseAdded(address indexed user, uint256 expenseId, string category, uint256 amount);
    event SpendingLimitUpdated(address indexed user, uint256 newLimit);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
        nextExpenseId = 1;
    }

    /**
     * @notice Add a new expense.
     * @param _category Category of expense (e.g., Food, Travel, Utilities)
     * @param _amount Amount spent
     * @param _description Short description of the expense
     */
    function addExpense(
        string calldata _category,
        uint256 _amount,
        string calldata _description
    ) external {
        require(_amount > 0, "Amount must be greater than zero");

        Expense memory newExpense = Expense({
            id: nextExpenseId,
            category: _category,
            amount: _amount,
            description: _description,
            timestamp: block.timestamp
        });

        userExpenses[msg.sender].push(newExpense);
        nextExpenseId++;

        emit ExpenseAdded(msg.sender, newExpense.id, _category, _amount);
    }

    /**
     * @notice Set a personalized spending limit for a user.
     * @param _user Address of the user
     * @param _limit Spending limit in wei
     */
    function setSpendingLimit(address _user, uint256 _limit) external onlyOwner {
        spendingLimit[_user] = _limit;
        emit SpendingLimitUpdated(_user, _limit);
    }

    /**
     * @notice Get all expenses of a user.
     * @param _user Address of the user
     * @return Array of Expense structs
     */
    function getUserExpenses(address _user) external view returns (Expense[] memory) {
        return userExpenses[_user];
    }
}

