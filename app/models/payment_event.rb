class PaymentEvent < ActiveRecord::Base
  attr_accessible :paid, :paid_on, :payment_date, :payment_id
  belongs_to :payment

  scope :not_paid, lambda {
    where(:paid => [false, nil])
  }

  scope :paid, lambda {
    where(:paid => true)
  }

  scope :sorted, lambda {
    order("payment_date DESC")
  }

  scope :late, lambda {
    where("payment_date < ?", Date.today)
  }

  scope :current_month, lambda {
    y = Date.today.year
    m = Date.today.month
    where(:payment_date => (Date.new(y, m, 1) .. Date.new(y, m, -1)))
  }
end
