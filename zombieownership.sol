pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";

// Solidity can inherit from multiple contracts
contract ZombieOwnership is ZombieAttack, ERC721 {

}
