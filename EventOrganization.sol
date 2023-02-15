// SPDX-License-Identifier: MIT

pragma solidity^0.8.0;

contract EventOrg {
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;

    uint nextId = 0;

    function CreateEvent(string memory name, uint date, uint price, uint ticketCount) public{
        require(date>block.timestamp, "event has to be set in future");
        require(ticketCount > 0, "tickets should be more than zero");

        events[nextId] = Event(msg.sender, name, date, price, ticketCount, ticketCount);
        nextId++;
    }

    function buyTickets(uint eventId, uint quantity) payable public {
        require(eventId<=nextId, "event does not exist");
        require(quantity<=events[eventId].ticketRemaining, "sorry tickets are finished");
        require(block.timestamp>events[eventId].date, "sorry event has already been over");
        require(msg.value==events[eventId].price*quantity, "havent paid enough eth");

        events[eventId].ticketRemaining -= quantity;
        tickets[msg.sender][eventId] += quantity;
    }

    function sendTicket(uint eventId, uint quantity, address to) public{
        require(eventId<=nextId, "event does not exist");
        require(block.timestamp>events[eventId].date, "sorry event has already been over");

        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId] += quantity;
    }
}