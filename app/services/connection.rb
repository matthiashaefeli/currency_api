require 'net/http'
require 'json'

class Connection

  # get current currency states
  def self.live
    uri = URI('http://api.currencylayer.com/live?')

    parameters = { access_key: Rails.application.credentials.currency[:access_key] }
    uri.query = URI.encode_www_form(parameters)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  # get Currencies names list
  def self.list
    uri = URI('http://api.currencylayer.com/list?')

    parameters = { access_key: Rails.application.credentials.currency[:access_key] }
    uri.query = URI.encode_www_form(parameters)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
