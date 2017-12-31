module Private
    module Deposits
      class RiecoinsController < ::Private::Deposits::BaseController
        include ::Deposits::CtrlCoinable
      end
    end
  end
  