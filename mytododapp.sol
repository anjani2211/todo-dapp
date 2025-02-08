// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract TodoList {
    struct Todo{
        uint id;
        string content;
        bool completed;
        address creator;

    }
    //array to store todo items
    Todo[] public todos;

    //mapping to track number of todos per user:
    mapping(address => uint) public userTodoCount;

    //events for tracking todo actions:
    event TodoCreated(uint id,string content,address creater);
    event TodoCompleted(uint id,bool completed);
    event TodoDeleted(uint id);
    event TodoUpdate(uint id,string newContent);

    //Modifier to check todo ownership:
    modifier onlyCreator(uint _id) {
        require(todos[_id].creator == msg.sender,"only creator can modify");
        _;
    }

    //create a new todo item
    function createTodo(string memory _content) public {
        //checking whether the input content has some length:
        require(bytes(_content).length > 0,"Todo content cannot be empty");

        uint id=todos.length;
        todos.push(Todo({
            id: id,
            content: _content,
            completed: false,
            creator: msg.sender
        }));
        
        userTodoCount[msg.sender]++;

        emit TodoCreated(id, _content,msg.sender);

    }
    // Mark a todo as completed:
    function toggleCompleted(uint _id) public onlyCreator(_id){
        todos[_id].completed =! todos[_id].completed;
        emit TodoCompleted(_id,todos[_id].completed);
    } 
    // update function
    function updateTodo(uint _id, string memory _newContent) public onlyCreator(_id){
        require(bytes(_newContent).length > 0,"Todo content cannot be empty");
        todos[_id].content = _newContent;
        emit TodoUpdate(_id,_newContent);

    }
    //delete a todo
    function deleteTodo(uint _id) public onlyCreator(_id){
        //replace the todo to delete with the last todo in the array
        todos[_id] = todos[todos.length-1];

        //update the id of the moved todo
        todos[_id].id = _id;
        //remove the last item
        todos.pop();

        //decrementthe user todos by one
        userTodoCount[msg.sender]--;
        emit TodoDeleted(_id);
    }
    

    //read functions
    //get all todos function
    function getAllTodos() public view returns (Todo[] memory){
        return todos;
    }
    //get todos
    function getUserTodos() public view returns (Todo[] memory){
        Todo[] memory userTodos = new Todo[](userTodoCount[msg.sender]);
        uint counter =0;

        for (uint i=0; i<todos.length;i++) {
            userTodos[counter]=todos[i];
            counter++;
        }
        
        return userTodos;

    }
    //to get the todo counts:
    function getTotalTodoCounts() public view returns(uint){
        return todos.length;
    }
}
