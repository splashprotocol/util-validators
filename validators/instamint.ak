use aiken/collection/dict
use aiken/collection/list
use aiken/collection/pairs
use cardano/assets.{PolicyId, tokens}
use cardano/transaction.{OutputReference, Transaction, find_input}

pub type Action {
  Mint
  Burn
}

validator instamint(ref: OutputReference) {
  mint(action: Action, policy: PolicyId, self: Transaction) {
    let amounts = tokens(self.mint, policy) |> dict.to_pairs |> pairs.values
    when action is {
      Mint -> {
        expect Some(_) = find_input(self.inputs, ref)
        amounts |> list.all(fn(n) { n > 0 })
      }
      Burn -> amounts |> list.all(fn(n) { n < 0 })
    }
  }

  else(_) {
    fail
  }
}
