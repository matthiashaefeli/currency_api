# CurrenciesController
class CurrenciesController < ApplicationController
  before_action :authenticate_request!

  # GET /currencies
  def index
    begin
      currencies =
        if params[:filter]
          currency_name = CurrencyName.find_by(shortening: params[:filter])
          Currency.where(currency: currency_name.title)
        else
          Currency.all
        end

      if params[:sort]
        currencies = currencies.sort_by { |c| c.send(params[:sort]) }
      end
    rescue
      payload = { error: 'Bad Request',
                  status: 400 }
      render json: payload, status: :bad_request and return
    end
    render json: currencies, status: :ok
  end

  # GET /currencies/:id
  def show
    if !Currency.exists?(params[:id])
      payload = { error: 'Currency with this id does not exists',
                  status: 400 }
      render json: payload, status: :bad_request
    else
      render json: Currency.find(params[:id]), status: :ok
    end
  end

  # POST /currencies
  def create
    if CurrencyName.exists?(shortening: params[:currency])
      currencies = Connection.live
      currency = currencies['quotes'].select { |k, _| k == 'USD' + params[:currency] }.flatten
      save_currency(params[:currency], currency[1])
    else
      payload = { status: 400,
                  error: "There is no currency with the name #{params[:currency]}" }
      render json: payload, status: :bad_request
    end
  end

  # DELETE /currencies
  def destroy
    currency = Currency.find(params[:id])
    currency.delete
    render json: { status: 200 }, status: :ok
  end

  def currency_names
    render json: CurrencyName.pluck(:title, :shortening), status: :ok
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
