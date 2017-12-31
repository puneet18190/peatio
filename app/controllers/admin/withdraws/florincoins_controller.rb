module Admin
    module Withdraws
      class FlorincoinsController < ::Admin::Withdraws::BaseController
        load_and_authorize_resource :class => '::Withdraws::Florincoin'
  
        def index
          start_at = DateTime.now.ago(60 * 60 * 24)
          @one_florincoins = @florincoins.with_aasm_state(:accepted).order("id DESC")
          @all_florincoins = @florincoins.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
        end
  
        def show
        end
  
        def update
          @florincoin.process!
          redirect_to :back, notice: t('.notice')
        end
  
        def destroy
          @florincoin.reject!
          redirect_to :back, notice: t('.notice')
        end
      end
    end
  end
  