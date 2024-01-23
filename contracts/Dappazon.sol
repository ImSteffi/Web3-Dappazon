// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.16 <0.9.0;

contract Dappazon {
    
    address public owner;

    struct Item { // struct names start with a CAPITAL letter  
        // this just defines what a struct (structure) looks like
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    struct Order {
        uint256 time;
        // we can use other structs inside of structs
        Item item;
    }

    // Key Value (Key => Value) | with mapping we assign the key value and save it to state variable "items";
    mapping(uint256 => Item) public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256 => Order)) public orders;

    event Buy(address buyer, uint256 orderId, uint256 itemId);
    event List(string name, uint256 cost, uint256 quantity);
    
    modifier onlyOwner() {
        // check that ONLY the owner of the website can list items. True/false statement.
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // first we list the products

    function list(
        uint256 _id, 
        string memory _name, 
        string memory _category,
        string memory _image,
        uint256 _cost,
        uint256 _rating,
        uint256 _stock
        ) public onlyOwner {
        // create the product "Item" struct
        // in this case the first word "Item" is the type. Like string, bool, but it's the Item we created with struct at line 8.
        // after = Item(), now we are creating a new item. After that we will pass in the attributes.
        Item memory item = Item(
            _id, 
            _name, 
            _category, 
            _image, 
            _cost, 
            _rating, 
            _stock
            );

        // save the product "Item" struct to the blockchain
        // using the mapping on line 20 we created the items list.
        items[_id] = item;

        // Emit an event
        // this emits/calls the EVENT that was made in line 22
        // emit can be used to notify people if there has been an update/item added.
        emit List(_name, _cost, _stock);
    }

    // buy products
    function buy(uint256 _id) public payable {
        // receive Crypto | This part is done in the test (Dappazon.js)

        // Fetch item
        Item memory item = items[_id];

        // require enough ether to buy an item
        require(msg.value >= item.cost);

        // require item is in stock
        require(item.stock > 0);

        // create an order | Order is struct | memory is a location | order is a variable
        // (block.timestamp) is a global var like (msg.sender), that uses Epoch(sec.) to assign it to a new block that's being made.
        Order memory order = Order(block.timestamp, item);

        // Add order for user
        orderCount[msg.sender]++; // <-- Order ID
        orders[msg.sender][orderCount[msg.sender]] = order;

        // substract stock
        items[_id].stock = item.stock -1;

        // emit event
        emit Buy(msg.sender, orderCount[msg.sender], item.id);
    }

    // withdraw funds
    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}