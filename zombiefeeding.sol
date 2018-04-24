pragma solidity ^0.4.19;

import "./zombiefactory.sol";

//Creating an interface, this looks just like creating a new contract
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    //storage - written permanently to the blockchain
    //memory - will disappear when the function call ends
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    //Checking if Zombie comes from a Kitty
    if (keccak256(_species) == keccak256("kitty")){
      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // Adding Kitty as last argument indicating it was made fed on a Cat
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
