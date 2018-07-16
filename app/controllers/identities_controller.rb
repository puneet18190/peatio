require 'pry'
require 'json'
class IdentitiesController < ApplicationController
  before_filter :auth_anybody!, only: :new
  before_filter :auth_anybody!, only: [:new, :registration1, :registration1]

  def new
    @identity = env['omniauth.identity'] || Identity.new
    render layout: false
  end

  def edit
    @identity = current_user.identity
  end

  def update
    @identity = current_user.identity

    unless @identity.authenticate(params[:identity][:old_password])
      redirect_to edit_identity_path, alert: t('.auth-error') and return
    end

    if @identity.authenticate(params[:identity][:password])
      redirect_to edit_identity_path, alert: t('.auth-same') and return
    end

    if @identity.update_attributes(identity_params)
      current_user.send_password_changed_notification
      clear_all_sessions current_user.id
      reset_session
      redirect_to signin_path, notice: t('.notice')
    else
      render :edit
    end
  end

  def registration2

    

    #Currency.codes.delete("btc")
    #create_anonymous_user
    
     
    Currency.codes.clear
    
    @currency = []
    @currency << params["currency1"] << params["currency2"] << params["currency3"]<< params["currency4"]<<params["currency5"]<<params["currency6"]<<params["currency7"]<<params["currency8"]
    @currency = @currency.compact
  
    @currency.each do |coin|
      Currency.codes.push(coin)
    end
    
    @sessions = SessionsController.new
    @sessions.request = request;
    @sessions.response = response;
    @sessions.create_anonymous_user(params["username"], params["password"])
    
    @payment_method = params["radio-group"]
    @data = []
    @json = []
    
    
    #create wallets ############################################################3
      current_user.accounts.each do |account|
        next if not account.currency_obj.coin?
        if account.payment_addresses.blank?
          
          account.payment_addresses.create(currency: account.currency)
          
        end
      end
      
     # binding.pry
      #sleep(0.5)
    #  current_user.reload
      current_user.accounts.each do |account|
        
        next if not account.currency_obj.coin?
        if account.payment_addresses.blank?
          account.payment_addresses.create(currency: account.currency)
        else
          address = account.payment_addresses.last
          
          payload = { payment_address_id: address.id, currency: account.currency}
          
          pub_key = gen_new_address(payload) if address.address.blank?

          addressPK  = CoinRPC[account.currency].dumpprivkey(pub_key)
          @data.push([account.currency, pub_key, addressPK])
          
        end
      end
     # current_user.accounts.each do |account|
       # v = account.payment_addresses
      #  unless v.blank?
      #    account.payment_addresses[0].reload
         
      #    address = account.payment_addresses[0].address
          
       #   addressPK  = CoinRPC[account.currency].dumpprivkey(address)
       #   @data.push([account.currency, address, addressPK])
       #   puts(account.currency)
      #    puts(addressPK)
     #   end  
   #   end
   
    
    #binding.pry
    
    case params["radio-group"]
    when "usb"
      render "usb"
    when "wallet"
      render "wallet"
    when "file"
      @json = @data.map do |c|
        { :coin => c[0], :public_key => c[1], :private_key => c[2] }
      end
      @json = {'json_keys' => @json}
      @json = JSON.pretty_generate(@json, {indent: "\t", object_nl: "\n"})
      
      render "file" 
    else
      redirect_to "/funds"
    end
  end

  def gen_new_address(payload)
    payload.symbolize_keys!

    payment_address = PaymentAddress.find payload[:payment_address_id]
    return if payment_address.address.present?

    currency = payload[:currency]
    if currency == 'eth'
      address  = CoinRPC[currency].personal_newAccount("")
      open('http://your_eth_server_ip/cgi-bin/restart.cgi')
    else
      address  = CoinRPC[currency].getnewaddress("payment")
    end

    
    if payment_address.update address: address
      ::Pusher["private-#{payment_address.account.member.sn}"].trigger_async('deposit_address', { type: 'create', attributes: payment_address.as_json})
    end

    return address
  end


  def wallet
    @data = JSON.parse(params["data"])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "wallet"
      end
    end
  end

 

  private
  def identity_params
    params.required(:identity).permit(:password, :password_confirmation)
  end
end