// SPDX-License-Identifier: MIT

pragma solidity^0.8.0;

contract GDrive{
    struct Access {
        address user;
        bool access;
    }

    mapping(address=>string[]) images;
    mapping(address=>mapping(address=>bool)) ownership;
    mapping(address=>Access[]) accessList;
    mapping(address=>mapping(address=>bool)) previousUser;

    address owner;

    constructor (){
        owner = msg.sender;
    }

    function upload(string memory url) public {
        images[msg.sender].push(url);
    }
    function giveAccess(address user) public{
        ownership[msg.sender][user] = true;
        if(previousUser[msg.sender][user]) {
            for(uint i=0; i<accessList[msg.sender].length; i++){
                if(accessList[msg.sender][i].user == user){
                    accessList[msg.sender][i].access = true;
                }
            }
        }
        else{
            accessList[msg.sender].push(Access(user,true));
            previousUser[msg.sender][user] = true;    
        }
    }
    function removeAccess(address user) public{
        ownership[msg.sender][user]=false;
        for(uint i=0; i<accessList[msg.sender].length; i++){
            if(accessList[msg.sender][i].user == user){
                accessList[msg.sender][i].access = false;
            }
        }
    }
    function getFiles(address _user) public view returns(string[] memory)  {
        require(ownership[_user][msg.sender] || _user==msg.sender , "u aint got no access bruh");
        return images[_user];
    }
    function shareAccess() view public returns(Access[] memory){
        return accessList[msg.sender];
    }
}