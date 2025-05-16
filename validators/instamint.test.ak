use cardano/address.{from_script}
use cardano/assets.{PolicyId, add, from_asset, from_lovelace}
use cardano/transaction.{
  Input, NoDatum, Output, OutputReference, Transaction, placeholder,
}
use instamint.{Burn, Mint}

test multimint() {
  let self_policy: PolicyId = "self"
  let oref = OutputReference { transaction_id: "tx_id", output_index: 0 }
  let input =
    Input(oref, Output(from_script("addr"), from_lovelace(1000), NoDatum, None))
  let tx =
    Transaction {
      ..placeholder,
      inputs: [input],
      mint: from_asset(self_policy, "A", 1) |> add(self_policy, "B", 100),
    }

  instamint.instamint.mint(oref, Mint, self_policy, tx)
}

test multiburn() {
  let self_policy: PolicyId = "self"
  let oref = OutputReference { transaction_id: "tx_id", output_index: 0 }
  let tx =
    Transaction {
      ..placeholder,
      mint: from_asset(self_policy, "A", -1) |> add(self_policy, "B", -100),
    }

  instamint.instamint.mint(oref, Burn, self_policy, tx)
}

test mint_and_burn() {
  let self_policy: PolicyId = "self"
  let oref = OutputReference { transaction_id: "tx_id", output_index: 0 }
  let input =
    Input(oref, Output(from_script("addr"), from_lovelace(1000), NoDatum, None))
  let tx =
    Transaction {
      ..placeholder,
      inputs: [input],
      mint: from_asset(self_policy, "A", 1) |> add(self_policy, "B", -1),
    }

  !or {
    instamint.instamint.mint(oref, Mint, self_policy, tx),
    instamint.instamint.mint(oref, Burn, self_policy, tx),
  }
}
