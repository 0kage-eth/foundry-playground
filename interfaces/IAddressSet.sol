//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

interface IAddressSet{
    struct AddressSet {
       address[] addresses;
       mapping(address => bool) addressExists; 
    }

    
}