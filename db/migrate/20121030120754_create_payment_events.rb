class CreatePaymentEvents < ActiveRecord::Migration
  def change
    create_table :payment_events do |t|
      t.integer :payment_id
      t.boolean :paid
      t.datetime :paid_on
      t.date :payment_date

      t.timestamps
    end
  end
end
