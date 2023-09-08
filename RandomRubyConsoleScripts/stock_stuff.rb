class Analyzer
  attr_accessor :csv, :data

  def voo
    @voo ||= '/Users/andyspix/Downloads/VOO.csv'
  end

  def vti
    @vti ||= '/Users/andyspix/Downloads/VTI.csv'
  end

  def initialize(input = voo)
    @csv = read_csv(input)
    chew_csv
  end

  def delta(date1, date2, field = :close)
    return unless @data.key?(date1) && @data.key?(date2)

    @data[date1][field] - @data[date2][field]
  end

  def max_monthly_deltas(field = :close)
    result = {}
    max = 0
    curr_month = @data[:dates].first.month
    @data[:dates].each do |d|
      if curr_month != d.month
        curr_month = d.month
        max = 0
      end

      delta = delta(d, d + 1.month, field)
      max = delta.to_f.abs > max.to_f.abs ? delta : max
      result["#{d.year} - #{d.month}"] = max
    end
    result
  end

  def chew_csv
    @data = {}
    @csv.each do |row|
      date = Date.parse(row['Date'])
      @data[date] ||= {}
      @data[date][:open]      = row['Open'].to_f
      @data[date][:high]      = row['High'].to_f
      @data[date][:low]       = row['Low'].to_f
      @data[date][:close]     = row['Close'].to_f
      @data[date][:adj_close] = row['Adj Close'].to_f
      @data[date][:volume]    = row['Volume'].to_f
    end
    @data[:dates] = @data.keys
  end
end
