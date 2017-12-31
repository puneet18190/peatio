module Private
    module Withdraws
      class FlorincoinsController < ::Private::Withdraws::BaseController
        include ::Withdraws::Withdrawable
      end
    end
  end
  