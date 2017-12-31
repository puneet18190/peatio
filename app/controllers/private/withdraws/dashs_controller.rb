module Private
    module Withdraws
      class DashsController < ::Private::Withdraws::BaseController
        include ::Withdraws::Withdrawable
      end
    end
  end
  