class CurrenciesController < ApplicationController
  before_action :authenticate_request!

  def index
    currencies = Currency.order(:created_at)
    render json: currencies.as_json
  end

  def show
    if !Currency.exists?(params[:id])
      render json: { error: 'Currency with this id does not exists'}
    else
      render json: Currency.find(params[:id]).as_json
    end
  end

  def create
    binding.pry
    currencies = Connection.live

    currency = currencies['quotes'].select { |k, v| k == params[:currency] }.flatten
    save_currency(params[:currency], currency[1])
    # change currency name to real name
    # currency[0] is the name for now but we have to change that

    render json: {{ currency: currency[0], value: currency[1] }, status: :ok}
  end

  def destroy
    currency = Currency.find(params[:id])
    currency.delete
    render json: { status: 200 }
  end

  private

  def save_currency(currency, value)
    currency = Currency.new(currency: currency, value: value)
    currency.save
  end
end
