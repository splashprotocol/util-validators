use aiken/collection/list
use cardano/assets.{PolicyId, quantity_of}
use cardano/transaction.{OutputReference, Transaction}

validator instamint(ref: OutputReference) {
  mint(name: ByteArray, policy: PolicyId, self: Transaction) {
    let amount_minted = quantity_of(self.mint, policy, name)
    if amount_minted > 0 {
      expect Some(first_input) = list.at(self.inputs, 0)
      first_input.output_reference == ref
    } else {
      True
    }
  }

  else(_) {
    fail
  }
}
