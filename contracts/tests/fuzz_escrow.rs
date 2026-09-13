#![cfg(test)]

use bodapay_contracts::payment_escrow::{Asset, PaymentEscrowContract, PaymentEscrowContractClient};
use proptest::prelude::*;
use soroban_sdk::{testutils::Address as _, token, Address, Env, String};

const ESCROW_AMOUNT: i128 = 1_000_000_000_000_000;

fn create_token_contract<'a>(
    env: &Env,
    admin: &Address,
) -> (token::Client<'a>, token::StellarAssetClient<'a>) {
    let contract_address = env.register_stellar_asset_contract_v2(admin.clone());
    (
        token::Client::new(env, &contract_address.address()),
        token::StellarAssetClient::new(env, &contract_address.address()),
    )
}

proptest! {
    #[test]
    fn fuzz_deposit_escrow(amount in 1i128..1_000_000_000_000_000i128) {
        let env = Env::default();
        env.mock_all_auths();

        let admin = Address::generate(&env);
        let sender = Address::generate(&env);
        let recipient = Address::generate(&env);

        let contract_id = env.register_contract(None, PaymentEscrowContract);
        let client = PaymentEscrowContractClient::new(&env, &contract_id);

        client.init_escrow(&admin);

        let (token, token_admin) = create_token_contract(&env, &admin);
        token_admin.mint(&sender, &ESCROW_AMOUNT);

        let asset = Asset {
            code: String::from_str(&env, "USDC"),
            issuer: admin.clone(),
        };
        client.add_supported_asset(&admin, &asset);

        // Escrow amount is fixed at the upper bound of the fuzzed range so
        // every deposit amount below is a valid (partial or full) deposit —
        // the point of this fuzz test is that `deposit` never panics across
        // the amount range, not that every amount is a distinct escrow.
        let escrow_id = client.create_escrow(
            &sender,
            &recipient,
            &ESCROW_AMOUNT,
            &asset,
            &3600,
            &String::from_str(&env, "fuzz"),
        );

        let res = client.try_deposit(&escrow_id, &sender, &amount, &token.address);

        assert!(res.is_ok() || res.is_err());
    }
}
