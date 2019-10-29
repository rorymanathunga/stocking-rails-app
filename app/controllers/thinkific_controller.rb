require 'securerandom' unless defined?(SecureRandom)

class ThinkificController < ApplicationController
  # Configuration
  # THINKIFIC_API_KEY = ENV["THINKIFIC_API_KEY"]
  # THINKIFIC_SUBDOMAIN = ENV["THINKIFIC_SUBDOMAIN"]
  THINKIFIC_API_KEY = "828ed116df8af1ac464bdb4cec121d1c"
  THINKIFIC_SUBDOMAIN = "manasports"

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
      :iat   => iat,
      :jti   => jti,
      :first_name  => user.first_name,
      :last_name => user.last_name,
      :email => user.email,
     }, THINKIFIC_API_KEY)
    redirect_to thinkific_sso_url(payload)
  end


  def thinkific_sso_url(payload)
    url = "http://#{THINKIFIC_SUBDOMAIN}.thinkific.com/api/sso/v2/sso/jwt?jwt=#{payload}"
    url += "&return_to=#{URI.escape(params["return_to"])}" if params["return_to"].present?
    url += "&error_url=#{URI.escape(params["error_url"])}" if params["error_url"].present?
    url
  end

end
