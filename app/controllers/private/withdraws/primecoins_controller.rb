module Private
    module Withdraws
      class PrimecoinsController < ::Private::Withdraws::BaseController
        include ::Withdraws::Withdrawable
      end
    end
  end
  