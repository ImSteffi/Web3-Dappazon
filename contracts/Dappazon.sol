// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract Dappazon {
    
    address public owner;

    struct Item {
        // this just defines what a struct (structure) looks like
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    // Key Value (Key => Value) | with mapping we assign the key value and save it to state variable "items";
    mapping(uint256 => Item) public items;

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
    // withraw funds
}