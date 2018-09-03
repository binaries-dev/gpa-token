pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

/**
 * @title GPA Token
 * @dev The main GPA token contract
 */
contract GPAToken is StandardBurnableToken, MintableToken {

  string public name = "Game Platform Accelerator Token";
  string public symbol = "GPA";
  uint public decimals = 18;

  bool public pubTrade = false;

  mapping(address => bool) private freezeList;
  address[] private indexFreezeList;

  event AddFreezeUser(address indexed addr);
  event RemoveFreezeUser(address indexed addr);
  event StartPublicTrade();
  event StopPublicTrade();

  /**
   * @dev modifier that throws if trading has not started yet
   */
  modifier allowedTrade() {
    require(pubTrade || owner == msg.sender);
    require(!_isFreezeList());
    _;
  }

  /*
 * @dev Fix for the ERC20 short address attack
 */
 modifier onlyPayloadSize(uint size) {
   assert(msg.data.length >= size + 4);
   _;
 }

  function _isFreezeList() internal view returns (bool) {
      return (freezeList[msg.sender] ? freezeList[msg.sender] : false);
  }

  /**
   * @dev Checking if you are a freeze member.
   */
  function checkFreeze(address _addr) public view returns (bool) {
      return freezeList[_addr];
  }

  /**
   * @dev Get a list of freeze members.
   */
  function getFreezeList() public view onlyOwner returns (address[]) {
      return indexFreezeList;
  }

  /**
   * @dev Adding as a freeze member.
   */
  function addFreeze(address _addr) public onlyOwner {
      if(!freezeList[_addr]) {
        indexFreezeList.push(_addr);
      }
      freezeList[_addr] = true;
      emit AddFreezeUser(_addr);
  }

  /**
   * @dev Removing from freeze member.
   */
  function removeFreeze(address _addr) public onlyOwner {
      freezeList[_addr] = false;
      emit RemoveFreezeUser(_addr);
  }

  /**
   * @dev Allows the owner to enable the public trading.
   */
  function startPubTrade() public onlyOwner {
    pubTrade = true;
    emit StartPublicTrade();
  }

  /**
   * @dev Allows the owner to disable the trading.
   */
  function stopPubTrade() public onlyOwner {
    pubTrade = false;
    emit StopPublicTrade();
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public allowedTrade onlyPayloadSize(2 * 32) returns (bool) {
    emit Transfer(msg.sender, _to, _value);
    return super.transfer(_to, _value);
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public allowedTrade onlyPayloadSize(2 * 32) returns (bool) {
    emit Transfer(_from, _to, _value);
    return super.transferFrom(_from, _to, _value);
  }

}
