module Withdraws
    class Riecoin < ::Withdraw
      include ::AasmAbsolutely
      include ::Withdraws::Coinable
      include ::FundSourceable
    end
  end
  