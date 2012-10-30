class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :name
      t.decimal :amount
      t.date :start_date
      t.date :end_date
      t.integer :month_day
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
