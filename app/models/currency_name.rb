class CurrencyName < ApplicationRecord
  def self.create(list)
    list['currencies'].each do |k, v|
      currency_name = CurrencyName.new(shortening: k, title: v)
      currency_name.save
    end
  end
end
