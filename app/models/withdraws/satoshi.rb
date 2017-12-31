module Withdraws
  class Satoshi < ::Withdraw
    include ::AasmAbsolutely
    include ::Withdraws::Coinable
    include ::FundSourceable

    def set_fee
      self.fee = "0.00011".to_d
    end
  end
end
