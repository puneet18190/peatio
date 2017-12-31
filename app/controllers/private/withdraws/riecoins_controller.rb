module Private
    module Withdraws
      class RiecoinsController < ::Private::Withdraws::BaseController
        include ::Withdraws::Withdrawable
      end
    end
  end
  