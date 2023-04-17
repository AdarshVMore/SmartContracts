// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Hospital {

    struct record{
        
        address patientAddress;
        string doctorName;
        string symptoms;
        string diagnosis;
        string treatment;
        string Medication;
        string details;
        string report;
        string bill;
    }
    
    struct patient {
        string name;
        uint age;
        address[] doctorAccessList;
        record[] records;
    }
    
    struct doctor {
        string name;
        uint age;
        address[] patientAccessList;
    }

    address[] public patientList;
    address[] public doctorList;
    record[] public recordList;

    mapping (address => patient) patientInfo;
    mapping (address => doctor) doctorInfo;
    mapping (address => address) Empty;
    mapping (address => record) patientRecords;
    
    function add_agent(string memory _name, uint _age, uint _designation) public returns(string memory){
        address addr = msg.sender;
        
        if(_designation == 0){
            patientInfo[msg.sender].name = _name;
            patientInfo[msg.sender].age = _age;
            patientList.push(addr);
            return _name;
        }
       else if (_designation == 1){
            doctorInfo[addr].name = _name;
            doctorInfo[addr].age = _age;
            doctorList.push(addr);
            return _name;
       }
       else{
           revert();
       }
    }

    function add_record(address _patientAddress, string memory _doctorName , string memory _symptoms, string memory _diagnosis, string memory _treatment, string memory _medication, string memory _detail, string memory _report, string memory _bill) public {
        record memory new_record = record(_patientAddress,_doctorName, _symptoms, _diagnosis, _treatment, _medication, _detail, _report, _bill);
        patientInfo[_patientAddress].records.push(new_record);
    }

    function add_record_byDoctor() public view returns (bool) {
        bool doctorsAccess = false;
        for(uint i = 0;i<patientInfo[msg.sender].doctorAccessList.length;i++){
            if(msg.sender == patientInfo[msg.sender].doctorAccessList[i]){
                doctorsAccess = true;
            }
            else {
                revert();
            }            
        }
        return doctorsAccess;
    }

    function get_patient(address addr) view public returns (string memory , uint, record[] memory){
        return (patientInfo[addr].name, patientInfo[addr].age, patientInfo[addr].records);
    }
    
    function get_doctor(address addr) view public returns (string memory , uint){
        return (doctorInfo[addr].name, doctorInfo[addr].age);
    }
    
    function get_patient_doctor_name(address paddr, address daddr) view public returns (string memory , string memory ){
        return (patientInfo[paddr].name,doctorInfo[daddr].name);
    }

    function permit_access(address addr) public {        
        doctorInfo[addr].patientAccessList.push(msg.sender);
        patientInfo[msg.sender].doctorAccessList.push(addr);
    }

    function remove_element_in_array(address[] storage Array, address addr) internal  {
        bool check = false;
        uint del_index = 0;
        for(uint i = 0; i<Array.length; i++){
            if(Array[i] == addr){
                check = true;
                del_index = i;
            }
        }
        if(!check) revert();
        else{
            if(Array.length == 1){
                delete Array[del_index];
            }
            else {
                Array[del_index] = Array[Array.length - 1];
                delete Array[Array.length - 1];
            }
        }
    }

    function remove_patient(address paddr, address daddr) public {
        remove_element_in_array(doctorInfo[daddr].patientAccessList, paddr);
        remove_element_in_array(patientInfo[paddr].doctorAccessList, daddr);
    }

    function get_accessed_doctorlist_for_patient(address addr) public view returns (address[] memory ){ 
        address[] storage doctoraddr = patientInfo[addr].doctorAccessList;
        return doctoraddr;
    }


    function revoke_access(address daddr) public {
        remove_patient(msg.sender,daddr);
    }

    function get_patient_list() public view returns(address[] memory ){
        return patientList;
    }

    function get_doctor_list() public view returns(address[] memory ){
        return doctorList;
    }
}
