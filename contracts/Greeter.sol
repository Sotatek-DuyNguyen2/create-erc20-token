//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Greeter is ERC20, Ownable {
    mapping(address => bool) blackList;
    address treasury;
    constructor(address _treasury) ERC20("token ERC20 test", "NTD2") {
        treasury = _treasury;
    }

    function mint(address account, uint256 amount) public onlyOwner{
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }
    function addToBlackList(address _account) public onlyOwner {
        blackList[_account] = true;
    }
    function removeFromBlacklist(address _account) public onlyOwner {
        blackList[_account] = false;
    }
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(blackList[from] == false, "");
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fee = amount * 5/100;

        uint256 fromBalance = _balances[from];
        
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount - fee;
        _balances[treasury] += fee;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }
}
