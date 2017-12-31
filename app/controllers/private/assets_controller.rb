module Private
  class AssetsController < BaseController
    skip_before_action :auth_member!, only: [:index]

    def index
      @cny_assets  = Currency.assets('cny')
      @btc_proof   = Proof.current :btc
      @cny_proof   = Proof.current :cny
      @ltc_proof   = Proof.current :ltc
      @doge_proof   = Proof.current :doge
      @dash_proof   = Proof.current :dash
      @ric_proof   = Proof.current :ric
      @ppc_proof   = Proof.current :ppc
      @xpm_proof   = Proof.current :xpm
      @flo_proof   = Proof.current :flo

      if current_user
        @btc_account = current_user.accounts.with_currency(:btc).first
        @cny_account = current_user.accounts.with_currency(:cny).first
        @ltc_account = current_user.accounts.with_currency(:ltc).first
        @doge_account = current_user.accounts.with_currency(:doge).first
        @dash_account = current_user.accounts.with_currency(:dash).first
        @ric_account = current_user.accounts.with_currency(:ric).first
        @ppc_account = current_user.accounts.with_currency(:ppc).first
        @xpm_account = current_user.accounts.with_currency(:xpm).first
        @flo_account = current_user.accounts.with_currency(:flo).first
      end
    end

    def partial_tree
      account    = current_user.accounts.with_currency(params[:id]).first
      @timestamp = Proof.with_currency(params[:id]).last.timestamp
      @json      = account.partial_tree.to_json.html_safe
      respond_to do |format|
        format.js
      end
    end

  end
end
