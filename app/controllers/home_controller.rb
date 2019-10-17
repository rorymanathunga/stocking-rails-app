class HomeController < ApplicationController
  def index
    @client = IEX::Api::Client.new(
      publishable_token: 'Tpk_ccf8b92f0f0b405bbb17b313af8da443',
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    if params[:ticker]
      @stock = @client.key_stats(params[:ticker])
    end

  end
  def about
  end
end
