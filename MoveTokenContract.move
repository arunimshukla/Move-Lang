module my_addrx::basic_token {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct TokenInfo has key {
        total_supply: u64,
    }

    struct UserTokenStore has key {
        balance: u64,
    }

    public fun initialize(account: &signer) {
        assert!(signer::address_of(account) == @my_addrx, 0);
        move_to(account, TokenInfo { total_supply: 0 });
    }

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

    public fun balance_of(addr: address): u64 acquires UserTokenStore {
        if (!exists<UserTokenStore>(addr)) {
            return 0
        } else {
            let user_store = borrow_global<UserTokenStore>(addr);
            return user_store.balance
        }
    }

    public fun total_supply(): u64 acquires TokenInfo {
        borrow_global<TokenInfo>(@my_addrx).total_supply
    }
}
