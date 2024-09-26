# Move-Lang

This repository contains a simple implementation of a token contract written in Move for the Aptos blockchain. It demonstrates basic token functionality including minting, transferring, and querying balances.

![Move Programming Language Logo](https://d230m64oxp1vr8.cloudfront.net/blogs/codeZerosfm0wreu61686374734207.jpg?imwidth=1920&q=75)

## Table of Contents

|  Categorisation     
| -------------------------- |
| Contract Overview          | 
| Functionality              |
| Getting Started            |
| Usage                      |
| Important Considerations   |
| Contributing               |
| License                    |

## Contract Overview
The `basic_token` module implements a simple token system on the Aptos blockchain. It allows for:

- Initialization of the token contract.
  
- Minting new tokens.

- Transferring tokens between accounts.
  
- Querying token balances and total supply.

The contract uses two main structs:

1. `TokenInfo`: Stores the total supply of tokens.

2. `UserTokenStore`: Represents a user's token balance.

## Functionality

1. `initialize(account: &signer)`

Initializes the token contract. This should be called once by the contract owner.

```rust
public fun initialize(account: &signer) {
    assert!(signer::address_of(account) == @my_addrx, 0);
    move_to(account, TokenInfo { total_supply: 0 });
}
```

2. `mint(account: &signer, amount: u64)`

Mints new tokens and assigns them to the specified account.

```rust
public fun mint(account: &signer, amount: u64) acquires TokenInfo {
    let addr = signer::address_of(account);
    
    // Update total supply
    let token_info = borrow_global_mut<TokenInfo>(@my_addrx);
    token_info.total_supply = token_info.total_supply + amount;

    // Add tokens to user's balance
    if (!exists<UserTokenStore>(addr)) {
        move_to(account, UserTokenStore { balance: amount });
    } else {
        let user_store = borrow_global_mut<UserTokenStore>(addr);
        user_store.balance = user_store.balance + amount;
    }
}
```

3. `transfer(from: &signer, to: address, amount: u64)`

Transfers tokens from one account to another.

```rust
public fun transfer(from: &signer, to: address, amount: u64) acquires UserTokenStore {
    let from_addr = signer::address_of(from);
    assert!(exists<UserTokenStore>(from_addr), 1);
    assert!(exists<UserTokenStore>(to), 2);

    let from_store = borrow_global_mut<UserTokenStore>(from_addr);
    assert!(from_store.balance >= amount, 3);
    from_store.balance = from_store.balance - amount;

    let to_store = borrow_global_mut<UserTokenStore>(to);
    to_store.balance = to_store.balance + amount;
}
```

4. `balance_of(addr: address): u64`

Returns the token balance of a given address.

```rust
public fun balance_of(addr: address): u64 acquires UserTokenStore {
    if (!exists<UserTokenStore>(addr)) {
        return 0
    } else {
        let user_store = borrow_global<UserTokenStore>(addr);
        return user_store.balance
    }
}
```

5. `total_supply(): u64`

Returns the total supply of tokens.

``` rust
public fun total_supply(): u64 acquires TokenInfo {
    borrow_global<TokenInfo>(@my_addrx).total_supply
}
```

## Getting Started

To use this contract, you need to have the Aptos development environment set up. If you haven't already, follow the official Aptos documentation to set up your environment.

## Clone this repository:

``` git
git clone https://github.com/your-username/MOVE-LANG.git
```
``` git
cd move-lang
```

Modify the `my_addrx` address in the contract to your actual Aptos address.

### Compile the contract:

``` git
aptos move compile
```

### Run tests (if available):

``` git
aptos move test
```

### Publish the module to the Aptos blockchain:

```git
aptos move publish
```

# Usage

After deploying the contract, you can interact with it using the Aptos CLI or by writing a client application. Here are some example commands:

### Initialize the contract:

``` git
aptos move run --function-id 'your_address::basic_token::initialize
```

### Mint tokens:

``` git
aptos move run --function-id 'your_address::basic_token::mint' --args u64:1000
```

### Transfer tokens:

``` git
aptos move run --function-id 'your_address::basic_token::transfer' --args address:recipient_address u64:100
```

### Check balance:

``` git
aptos move run --function-id 'your_address::basic_token::balance_of' --args address:account_address
```

### Get total supply:
```git
aptos move run --function-id 'your_address::basic_token::total_supply
```

## Important Considerations

This is a basic implementation and lacks features that would be expected in a production-ready token contract, such as:

1. Proper access control (e.g., only allowing certain addresses to mint).

2. Events for important actions (minting, transferring).

3. Burning functionality

4. Approval mechanism for third-party transfers

5. Ensure you thoroughly test and audit the contract before using it with real assets.

6. The contract does not implement any token standards.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
