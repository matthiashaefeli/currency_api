class CreateCurrencyNames < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_names do |t|
      t.string :title
      t.string :shortening

      t.timestamps
    end
  end
end
