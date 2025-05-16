use aiken/collection/dict
use aiken/collection/list
use aiken/collection/pairs
use cardano/assets.{PolicyId, add, from_asset, tokens}
use cardano/script_context.{Minting, ScriptContext}
use cardano/transaction.{OutputReference, Transaction, placeholder}
use instamint.{Mint}

test mint_and_burn() {
  let self_policy: PolicyId = "self"
  let oref = OutputReference { transaction_id: "tx_id", output_index: 0 }
  let tx =
    Transaction {
      ..placeholder,
      mint: from_asset(self_policy, "A", 1) |> add(self_policy, "B", -1),
    }

  !instamint.mint(oref, Mint, self_policy, tx)
}
