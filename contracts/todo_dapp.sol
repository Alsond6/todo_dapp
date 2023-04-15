// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract TodoList {
    address public owner;

    enum Priority {
        LOW,
        MEDIUM,
        HIGH
    }
    
    struct TodoItem {
        string title;
        string description;
        uint256 dueDate;
        bool isCompleted;
        Priority priority;
    }

    mapping (address => TodoItem[]) private _todoItems;

    event NewTodoItem(address indexed owner, uint256 indexed todoId, string title, string description, uint256 dueDate, Priority priority);
    event TodoCompleted(address indexed owner, uint256 indexed todoId);
    event TodoDeleted(address indexed owner, uint256 indexed todoId);

    constructor() {
        owner = msg.sender;
    }

    function createTodoItem(string memory _title, string memory _description, uint256 _dueDate, Priority _priority) public {
        require (_dueDate > block.timestamp, "Due date must be greater than current time");

        TodoItem memory newTodoItem = TodoItem(_title, _description, _dueDate, false, _priority);
        _todoItems[msg.sender].push(newTodoItem);

        emit NewTodoItem(msg.sender, _todoItems[msg.sender].length - 1, _title, _description, _dueDate, _priority);
    }

    function completeTodo(uint256 _id) public {
        require(_id < _todoItems[msg.sender].length, "Invalid Todo ID");
        require(_todoItems[msg.sender][_id].isCompleted == false, "This Todo item has already been completed");

        _todoItems[msg.sender][_id].isCompleted = true;

        emit TodoCompleted(msg.sender, _id);
    }

    function getTodoList() public view returns (TodoItem[] memory) {
        return _todoItems[msg.sender];
    }

    function deleteTodo(uint256 _id) public {
        require(_id < _todoItems[msg.sender].length, "Invalid Todo ID");

        for (uint256 i = _id; i < _todoItems[msg.sender].length - 1; i++) {
            _todoItems[msg.sender][i] = _todoItems[msg.sender][i + 1];
        }
        
        _todoItems[msg.sender].pop();

        emit TodoDeleted(msg.sender, _id);
    }
}