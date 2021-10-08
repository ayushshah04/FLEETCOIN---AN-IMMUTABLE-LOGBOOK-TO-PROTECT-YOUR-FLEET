pragma solidity ^0.5.0;

import "./TRUXToken.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract CarsNFT is ERC721Full {

    constructor() ERC721Full("CarsNFT", "CARS") public { }

    using Counters for Counters.Counter;
    Counters.Counter token_ids;

    struct Car {
        string vin;
        uint logs;
        uint services;
    }
 
    // mapping between token_id and Car structure - this mapping will be used to get a specific vehicle for a token
    mapping(uint => Car) public cars;
    
    // mapping between token_id and IPFS URI holding vehicle info 
    mapping(uint => string) public vehicleinfo;
    
    
    // creating an instance of TRUXToken contract to mint TRUX token to the users of this system
    TRUXToken token = new TRUXToken("Reward Token", "TRUX");

    // event definition to log smart contract state changes when logs and service records are registered in the smart contract
    event Log(uint token_id, string log_report_uri);
    event Service(uint token_id, string service_report_uri);
    
    
    // FOLLOWING 3 FUNCTIONS ARE CALLED FROM PYTHON TO INPUT/UPDATE VEHICLE INFORMATION, LOGS AND SERVICE RECORDS IN THE BLOCKCHAIN
    // function to generate a new token id and mint the NFT token in blockchain
    function registerVehicle(address owner, string memory vin, string memory token_uri) public returns(uint) {
        token_ids.increment();
        uint token_id = token_ids.current();

        // mint the NFT token (representing the vehicle) and store the mapping between token_id and IPFS URI stroing the vehicle info
        _mint(owner, token_id);
        _setTokenURI(token_id, token_uri);

        // update Cars struct
        cars[token_id] = Car(vin, 0, 0);
        
        // update vehicleinfo struct 
        vehicleinfo[token_id] = token_uri;
        
        // reward TRUX tokens 
        token.rewardToken(owner, 1000);

        return token_id; //return token_id to python caller function
     }


    
    function registerLog(uint token_id, string memory log_report_uri) public returns(uint) {
        // increase log count for every log entry and then update addLogURI struct
        cars[token_id].logs += 1;
        addLogURI(token_id, log_report_uri);
        
        // reward TRUX tokens
        token.rewardToken(msg.sender, 100);

        // Permanently associates the report_uri with the token_id on-chain via Events for a lower gas-cost than storing directly in the contract's storage.
        emit Log(token_id, log_report_uri);

        return cars[token_id].logs; //return log count to python caller function
        }
        
        
    
    function registerService(uint token_id, string memory service_report_uri) public returns(uint) {
        // increase log count for every log entry and then update addLogURI struct
        cars[token_id].services += 1;
        addServiceURI(token_id, service_report_uri);
        
        // reward TRUX tokens
        token.rewardToken(msg.sender, 100);
       
        // Permanently associates the report_uri with the token_id on-chain via Events for a lower gas-cost than storing directly in the contract's storage.
        emit Service(token_id, service_report_uri);

        return cars[token_id].services; //return service count to python caller function
        }
    
    
    
    // FOLLOWING STRUCTS AND FUNCTIONS ARE CALLED FROM PYTHON TO RETRIEVE VEHICLE INFORMATION, LOGS AND SERVICE RECORDS FROM THE BLOCKCHAIN
    struct logURIStruct {                           // note that mapping between a vechile (token in blockchain) and logs is one to many - token_id => string[]
        string IPFS_URI;                            // however, string is an array of bytes and string[] is a 2-d array - not supported by solidity  
    }                                               // hence, this struct 
    mapping(uint => logURIStruct[]) logHistory;     // and then a mapping between between token_id and array of struct - each element of array is a struct and inside struct is the URI string of a log
                                                    // public visibility can't be used as solidity can't create getter and setter for array of struct. Hence visibility has to be either private or internal
                                                    // That means getter and setter functions have to explicityly defined. Hence following 3 PUBLIC functions - interface between python and structs which are INTERNAL
    function addLogURI(uint token_id, string memory log_uri) public {
        logHistory[token_id].push(logURIStruct(log_uri));
        }

    function getLogURI(uint token_id, uint index) public returns(string memory){
            return logHistory[token_id][index].IPFS_URI;
        }
        
    function getLogURICount(uint token_id) public returns(uint uriCount) {
            return logHistory[token_id].length;
        }
        
    
    // Similar logic and explanations are applicable for service records as well as again it's one to many relationship
    struct serviceURIStruct {
        string IPFS_URI;
    }
    mapping(uint => serviceURIStruct[]) serviceHistory;
    
    
    function addServiceURI(uint token_id, string memory service_uri) public {
        serviceHistory[token_id].push(serviceURIStruct(service_uri));
        }

    function getServiceURI(uint token_id, uint index) public returns(string memory){
            return serviceHistory[token_id][index].IPFS_URI;
        }
        
    function getServiceURICount(uint token_id) public returns(uint uriCount) {
            return serviceHistory[token_id].length;
        }
    }
