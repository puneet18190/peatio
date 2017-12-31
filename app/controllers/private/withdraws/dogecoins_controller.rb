module Private
    module Withdraws
      class DogecoinsController < ::Private::Withdraws::BaseController
        include ::Withdraws::Withdrawable
      end
    end
  end
  