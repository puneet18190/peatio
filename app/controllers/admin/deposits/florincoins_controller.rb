module Admin
    module Deposits
      class FlorincoinsController < ::Admin::Deposits::BaseController
        load_and_authorize_resource :class => '::Deposits::Florincoin'
  
        def index
          start_at = DateTime.now.ago(60 * 60 * 24 * 365)
          @florincoins = @florincoins.includes(:member).
            where('created_at > ?', start_at).
            order('id DESC').page(params[:page]).per(20)
        end
  
        def update
          @florincoin.accept! if @florincoin.may_accept?
          redirect_to :back, notice: t('.notice')
        end
      end
    end
  end
  