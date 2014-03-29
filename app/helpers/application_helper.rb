module ApplicationHelper

  def format_date obj
    formatted = obj.year.to_s
    formatted << '-' << format('%02d', obj.month) if obj.month > 0
    formatted << '-' << format('%02d', obj.day) if obj.day > 0
    formatted
  end

  def try_format_float float
    ('%.2f' % float) if float
  end

end
