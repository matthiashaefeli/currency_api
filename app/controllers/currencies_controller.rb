class CurrenciesController < ApplicationController
  before_action :authenticate_request!

  # get /currencies
  def index
    currencies = Currency.order(:created_at)
    render json: currencies, status: :ok
  end

  # get /currencies/:id
  def show
    if !Currency.exists?(params[:id])
      payload = { error: 'Currency with this id does not exists',
                  status: 400 }
      render :json => payload, :status => :bad_request
    else
      render json: Currency.find(params[:id]), status: :ok
    end
  end

  # post /currencies
  def create
    if CurrencyName.exists?(shortening: params[:currency])
      currencies = Connection.live
      currency = currencies['quotes'].select { |k, v| k == 'USD'+params[:currency] }.flatten
      save_currency(params[:currency], currency[1])
    else
      payload =  { status: 400,
                   error: "There is no currency with the name #{params[:currency]}" }
      render :json => payload, :status => :bad_request
    end
  end

  # delete /currencies
  def destroy
    currency = Currency.find(params[:id])
    currency.delete
    render json: { status: 200 }, status: :ok
  end

  private

  # save currency
  def save_currency(currency, value)
    currency_name = CurrencyName.find_by(shortening: currency)
    currency = Currency.new(currency: currency_name.title, value: value)
    currency.save
    render json: currency, status: :created, location: currency
  end
end
