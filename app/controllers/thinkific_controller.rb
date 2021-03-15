require 'securerandom' unless defined?(SecureRandom)

class ThinkificController < ApplicationController
  # Configuration
  THINKIFIC_API_KEY = "Replace with THINKIFIC_API_KEY"
  THINKIFIC_SUBDOMAIN = "Replace with THINKIFIC_SUBDOMAIN"

  def create
    if user_signed_in?
      user = current_user
    # if user = User.authenticate(params[:login], params[:password])
      # If the submitted credentials pass, then log user into Thinkific
      sign_into_thinkific(user)
    else
      render :new, :notice => "Invalid credentials"
    end
  end

  private

  def sign_into_thinkific(user)
    # This is the meat of the business, set up the parameters you wish
    # to forward to Thinkific. All parameters are documented in this page.


    iat = Time.now.to_i
    jti = "#{iat}/#{SecureRandom.hex(18)}"
    payload = JWT.encode({
      :iat   => iat - 500,
      :jti   => jti,
      :first_name  => user.first_name,
      :last_name => user.last_name,
      :email => user.email,
      :external_id => user.id
     }, THINKIFIC_API_KEY)
    redirect_to thinkific_sso_url(payload)
  end


  def thinkific_sso_url(payload)
    url = "http://#{THINKIFIC_SUBDOMAIN}.thinkific.com/api/sso/v2/sso/jwt?jwt=#{payload}"
    url += "&return_to=https://academy.manarugbycoach.com/courses/january-2021"
    url += "&error_url=#{URI.escape(params["error_url"])}" if params["error_url"].present?
    url
  end

end
