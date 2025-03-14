module ApplicationHelper

  def number_in_week (day)
    (day.wday - 1) % 7
  end
end
