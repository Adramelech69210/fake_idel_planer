module ApplicationHelper

  def number_in_week (day)
    (day.wday - 1) % 7
  end

  def is_today?(date)
    date.to_date == Date.today
  end

end
