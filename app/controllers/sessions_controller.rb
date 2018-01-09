require 'pry'
class SessionsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]

  before_action :auth_member!, only: :destroy
  before_action :auth_anybody!, only: [:new, :failure]
  before_action :add_auth_for_weibo

  helper_method :require_captcha?

  def new
    @identity = Identity.new
  end

  def identity_params
    #params.required(:identity).permit('111', '111')
  end

  def create_anonymous_user(username, passwordu)
  
  

    #@email = "E#{ROTP::Base32.random_base32(8).upcase}@SAFEWEX.com"
    
    @IDs = Identity.create(email: username, password: passwordu, password_confirmation: passwordu, is_active: true)
    
    @member = Member.create(email: @IDs.email, phone_number:'527132209', activated: true)
    
    @member.authentications.build(provider: 'identity', uid: @IDs.id)
    @member.tag_list.add 'vip'
    @member.tag_list.add 'hero'
    @member.save

    if @member
      if @member.disabled?
        increase_failed_logins
        redirect_to signin_path, alert: t('.disabled')
      else
        clear_failed_logins
        reset_session rescue nil
        session[:member_id] = @member.id
        save_session_key @member.id, cookies['_peatio_session']
        save_signup_history @member.id
      end
    else
      increase_failed_logins
      redirect_to signin_path, alert: t('.error')
    end
  end


  def create
    Currency.codes.delete('cny')
    puts("create in session ctrl")
    if !require_captcha? || simple_captcha_valid?
      @member = Member.from_auth(auth_hash)
    
    end
    
    if @member
      if @member.disabled?
        increase_failed_logins
        redirect_to signin_path, alert: t('.disabled')
      else
        clear_failed_logins
        reset_session rescue nil
        session[:member_id] = @member.id
        save_session_key @member.id, cookies['_peatio_session']
        save_signup_history @member.id
        MemberMailer.notify_signin(@member.id).deliver if @member.activated?
        redirect_back_or_settings_page
      end
    else
      increase_failed_logins
      redirect_to signin_path, alert: t('.error')
    end

    

    current_user.accounts.each do |account|
      next if not account.currency_obj.coin?
      if account.payment_addresses.blank?
        
        account.payment_addresses.create(currency: account.currency)
        
      end
    end

    current_user.accounts.each do |account|
      
      next if not account.currency_obj.coin?
    
      if account.payment_addresses.blank?
        
        account.payment_addresses.create(currency: account.currency)
        #address = account.payment_addresses.last
        #address.gen_address if address.address.blank?
      else
        address = account.payment_addresses.last
        address.gen_address if address.address.blank?
      end
    end



  end

  def failure
    increase_failed_logins
    redirect_to signin_path, alert: t('.error')
  end

  def destroy
    clear_all_sessions current_user.id
    reset_session
    redirect_to root_path
  end

  private

  def require_captcha?
    failed_logins > 3
  end

  def failed_logins
    Rails.cache.read(failed_login_key) || 0
  end

  def increase_failed_logins
    Rails.cache.write(failed_login_key, failed_logins+1)
  end

  def clear_failed_logins
    Rails.cache.delete failed_login_key
  end

  def failed_login_key
      "peatio:session:#{request.ip}:failed_logins"
  end

  def auth_hash
    @auth_hash ||= env["omniauth.auth"]
  end

  def add_auth_for_weibo
    if current_user && ENV['WEIBO_AUTH'] == "true" && auth_hash.try(:[], :provider) == 'weibo'
      redirect_to settings_path, notice: t('.weibo_bind_success') if current_user.add_auth(auth_hash)
    end
  end

  def save_signup_history(member_id)
    SignupHistory.create(
      member_id: member_id,
      ip: request.ip,
      accept_language: request.headers["Accept-Language"],
      ua: request.headers["User-Agent"]
      )
  end
end
