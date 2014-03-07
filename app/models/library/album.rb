module Library
  class Album < Sequel::Model(:libdb__albums)

    def date
      Date.new(year, month, day)
    end

    def original_date
      Date.new(original_year, original_month, original_day)
    end

  end
end
