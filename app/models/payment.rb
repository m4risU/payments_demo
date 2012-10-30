class Payment < ActiveRecord::Base
  attr_accessible :name, :amount, :start_date, :end_date, :month_day

  validates_presence_of :start_date, :end_date, :amount, :name, :month_day

  has_many :payment_events, :dependent => :destroy
  after_save :verify_payment_events

  private
  def verify_payment_events
    payment_events.not_paid.destroy_all

    payment_event_months.zip(payment_event_dates).each { |month_array, updated_payment_date|
      payment_event = payment_events.where(:payment_date => [(Date.new(month_array[0], month_array[1], 1) .. Date.new(month_array[0], month_array[1], -1))]).last
      if payment_event
        if !payment_event.paid?
          payment_event.update_attributes({:payment_date => updated_payment_date})
        end
      else
        if updated_payment_date
          self.payment_events.create(:payment_date => updated_payment_date)
        end
      end
    }
  end

  public
  def payment_event_dates
    payment_event_months.map { |year, month|
      possible_date = Date.new(year, month, Date.valid_date?(year, month, month_day) ? month_day : -1)
      if possible_date <= end_date && possible_date >= start_date
        possible_date
      else
        nil
      end
    }
  end

  def payment_event_months
    payment_months = []
    (start_date.year..end_date.year).each do |y|
      mo_start = (start_date.year == y) ? start_date.month : 1
      mo_end = (end_date.year == y) ? end_date.month : 12

      (mo_start..mo_end).each do |m|
        # get last day if 29, 30 or 31 were used on February
        payment_date = Date.new(y, m, Date.valid_date?(y, m, month_day) ? month_day : -1)
        if payment_date <= end_date && payment_date >= start_date
          payment_months += [[y, m]]
        end
      end
    end
    payment_months
  end
end
