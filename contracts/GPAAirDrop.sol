pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title GPA Token AirDrop
 * @dev The main GPA AirDrop contract
 */
contract GPAAirDrop is Ownable {
  using SafeMath for uint256;

  uint8 public decimals;
  ERC20Interface private targetToken;

  constructor() public {
    decimals = 18;
  }

  function execAirDrop(address _tokenAddr, address[] addrList, uint256[] valList) public onlyOwner returns (uint256) {
    targetToken = ERC20Interface(_tokenAddr);

    uint256 i = 0;
    uint256 allowanceValue = _allowanceRemain(targetToken);

    while (i < addrList.length) {
      require(allowanceValue >= valList[i]);

      targetToken.transferFrom(msg.sender, addrList[i], valList[i].mul(10 ** uint256(decimals)));

      allowanceValue.sub(valList[i]);
      i++;
    }
    return i;
  }

  function setDecimals(uint8 _decimals) public onlyOwner {
    decimals = _decimals;
  }

  function _allowanceRemain(ERC20Interface _targetToken) internal view returns (uint256) {
    return _targetToken.allowance(owner, this).div(10 ** uint256(decimals)) ;
  }

  function () public payable {
    revert();
  }

}

contract ERC20Interface {
    function totalSupply() public constant returns (uint256);
    function balanceOf(address tokenOwner) public constant returns (uint256 balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
    function transfer(address to, uint256 tokens) public returns (bool success);
    function approve(address spender, uint256 tokens) public returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }

}
