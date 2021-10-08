# FLEETCOIN - AN IMMUTABLE LOGBOOK TO PROTECT YOUR FLEET
---

FLEETCOIN is a blockchain based product that puts the true, complete history of your vehicle on the blockchain, creating a certified, unchangeable record of purchase, operation, maintenance, and repair to keep your business secure.

This repository contains implementation of MVP.  

Following are the files: 
* **cars_smart_contract.sol** - Solidity contract with business logic to register vehicle data, logbook data and service data on the chain
* **TRUXToken.sol** - contract to mint TRUX utility token to users such as FLEETowner, operator, servicers and attorney 
* **cars_smart_contract.json** - ABI file of cars_smart_contract.sol
* **crypto.py** - Python module for basic operations such as initiatilizng contract, convert user input to json, pin json to IPFS 
* **cars.ipynb** - Pythoin notebook for user interaction 


## How to run the code <br>
- Clone the entire repository - into a local folder <br>  
- create a .env file in the same directory with following keys:
    - PINATA_API_KEY - [you need to get the API key from https://app.pinata.cloud/]
    - PINATA_SECRET_API_KEY - [you need to get the SECRET_API key from https://app.pinata.cloud/]
    - WEB3_PROVIDER_URI - [copy Ganache RPC SERVER ip and port]
    - SMART_CONTRACT_ADDRESS - [address of the smartcontract cars_smart_contract.sol after deployment] 
- Run Ganache and setup metamask account with RPC server address in Ganache (example HTTP://127.0.0.1:8545)
- Compile cars_smart_contract.sol in remix and copy the ABI into cars_smart_contract.json which is in the same folder
- Deploy cars_smart_contract.sol through remix - make sure remix ENVIRONMENT is set to "Injected Web3"
- copy the contract address and paste it in .env file for "SMART_CONTRACT_ADDRESS" key.
- Compile and deploy TRUXToken.sol 

Open cars.ipynb in jupyter notebook and execute the cells. User interaction is in the last cell. 


<hr style="border:2px solid blue"> </hr>