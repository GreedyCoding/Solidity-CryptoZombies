//Source code should start with a "version pragma"
//Private and Internal functions, arrays and variables should start with underscore
pragma solidity ^0.4.19;

//Base Contract
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits; //10^dnaDigits

    //Basically an ES6 Class Object !does not have a constructor function
    struct Zombie {
        string name;
        uint dna;
    }

    //Creating an array for Zombie structs making it public and naming it zombies
    //For a public Array Solidity will automatically create a getter method for it
    Zombie[] public zombies;

    //Mapping the adress to a uint so you can look up the owner of the zombie
    mapping (uint => address) public ZombieOwner;
    //Mapping a uint to the adress so you can look up the ammount of zombies an adress has
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        //Using array index as ZombieID and pushing a new Zombie into the array
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        ZombieOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        //Shorting the DNA to 16 digits using the dnaModulus
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        //Message Sender Adress needs to have 0 zombies to be able to create a Zombie.
        require(ownerZombieCount[msg.sender] == 0);
        //Generating DNA according to input string(not really random lol)
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
