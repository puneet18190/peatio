
require 'pry'
require 'json'
require 'html/sanitizer'
class AuthController < ApplicationController
      skip_before_filter :verify_authenticity_token 


      def loginh
        begin
        
       
        json_keys = [];
        params[:keys].values.each do |coin|
          json_keys.push(ActionView::Base.full_sanitizer.sanitize(coin))
        end
        

        json_keys = JSON.parse(json_keys.to_json)
        create_user(json_keys)

      rescue => ex
        flash[:error] = "Invalid addresses!"
        redirect_to :back
       
      end
      end




      def json_login
        puts(66666666666666666666)
        begin
         json_keys = ActionView::Base.full_sanitizer.sanitize(params["json"])
         json_keys.gsub!("\r\n", '')
         json_keys = JSON.parse(json_keys)["json_keys"]
         create_user(json_keys)
        rescue => ex
          flash[:error] = "Invalid json!"
          redirect_to :back
         
        end

        
      
      end
      
     def create_user(json_keys)
      
      
      @addresses = json_keys.map {|row| row["public_key"]}
      @currenciesIds = json_keys.map {|row| Currency.getid(row["coin"])}
      @currencies_market_ids = json_keys.map {|row| Currency.get_market_id(row["coin"])}
      
      #Check private keys
      json_keys.each do |coin|
       
        addressPK  = CoinRPC[coin["coin"]].dumpprivkey(coin["public_key"])
        if(addressPK != coin["public_key"])
          flash[:error] = "The login failed ! the key do not match"
           
        end
      end
      
      Currency.codes.clear

     #create a user
     @sessions = SessionsController.new
     @sessions.request = request;
     @sessions.response = response;
     @sessions.create_anonymous_user 

     #cet back the currencies
     json_keys.each do |c|
        Currency.codes.push(c["coin"])
    end
     
     @memberID  = current_user.id

     #update keys and check if allready exist
     #??????????????????????????????

     @PaymentAddressAccounts = PaymentAddress.where('address in (?)', @addresses).select(:account_id)
     @PaymentAddressAccounts = @PaymentAddressAccounts.map{|x| x.account_id }
     
     @oldMemberID = Account.where('id = ?', @PaymentAddressAccounts[0]).select(:member_id)
     unless @oldMemberID.blank?
      @oldMemberID = @oldMemberID[0].member_id
     end 
     
     #update table accounts

     #@user = User.find_by(id: 1)
     Account.where('id in (?)', @PaymentAddressAccounts).update_all(member_id: @memberID)

     #update table deposits
     Deposit.where('account_id in (?)', @PaymentAddressAccounts).update_all(member_id: @memberID)

     #update table withdraws
     Withdraw.where('account_id in (?)', @PaymentAddressAccounts).update_all(member_id: @memberID)
     
     #update table orders
     Order.where('currency in (?) AND member_id = ?', @currencies_market_ids,@oldMemberID).update_all(member_id: @memberID)
     
     #update table trades
     Trade.where('currency in (?) AND ask_member_id = ?', @currencies_market_ids, @oldMemberID).update_all(ask_member_id: @memberID)

     #AccountVersions
     AccountVersion.where('account_id in (?)', @PaymentAddressAccounts).update_all(member_id: @memberID)

     #FundSources
     FundSource.where('currency in (?) AND member_id = ?', @currenciesIds, @oldMemberID).update_all(member_id: @memberID)
     redirect_to funds_path
     end
    
    
    end