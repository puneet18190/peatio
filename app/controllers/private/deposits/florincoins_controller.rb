module Private
    module Deposits
      class FlorincoinsController < ::Private::Deposits::BaseController
        include ::Deposits::CtrlCoinable
      end
    end
  end
  