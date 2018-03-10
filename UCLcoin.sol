//run on https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.21+commit.dfe3193c.js

pragma solidity ^0.4.13;

contract Uclcoin {
    string public constant name = 'Uclcoin';
    string public constant symbol = 'UCN';

    uint256 public rate; //256 bits
    uint256 public total; //circulating
    address public owner;

    mapping (address => uint256) public balances; //dictionary that maps addressess to money quantity holded

    event Burn(address indexed _from, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function Uclcoin(uint256 _value, uint256 _rate) {
        owner = msg.sender;
        total = _value;
        balances[msg.sender] = _value;
        rate = _rate;
    }

    function mint(address _to, uint256 _value) returns (bool success) {
        if (msg.sender != owner) revert(); //reverts whatever the call to the function did so far
        if (_to == 0x0) revert();

        balances[_to] += _value;
        total += _value;

        return true;
    }

    function burn(uint256 _value) returns (bool success) {
        if (balances[msg.sender] < _value) revert();
        balances[msg.sender] -= _value;
        total -= _value;
        Burn(msg.sender, _value);

        return true;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (_to != 0x0) revert();
        if (balances[msg.sender] < _value) revert();
        if (balances[_to] + _value < balances[_to]) revert(); //uint256 cant be negative, so we are checking for overflow
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);

        return true;
    }

}
