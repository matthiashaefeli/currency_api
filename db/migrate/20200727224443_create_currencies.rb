class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :currency
      t.numeric :value

      t.timestamps
    end
  end
end
