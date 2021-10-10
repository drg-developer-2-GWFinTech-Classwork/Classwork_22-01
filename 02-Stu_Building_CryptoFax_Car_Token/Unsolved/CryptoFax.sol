pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract CryptoFax is ERC721Full {

    constructor() ERC721Full("TokenName", "TKN") public { }

    using Counters for Counters.Counter;  // Attaches a library to a type.
    Counters.Counter token_ids;

    struct Car {
        string vin;
        uint accidents;
    }

    // Stores token_id => Car
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => Car) public cars;

    event Accident(uint token_id, string report_uri);  // Calling an event is an easy and cheap way to permanently log a URI or Uniform Resource Identifier.

    function registerVehicle(address owner, string memory vin, string memory token_uri) public returns(uint) {
        token_ids.increment();
        uint token_id = token_ids.current();
        _mint(owner, token_id);
        _setTokenURI(token_id, token_uri);
        cars[token_id] = Car(vin, 0);
        return token_id;
    }

    function reportAccident(uint token_id, string memory report_uri) public returns(uint) {
        cars[token_id].accidents += 1;
        emit Accident(token_id, report_uri);
        return cars[token_id].accidents;
    }
}
