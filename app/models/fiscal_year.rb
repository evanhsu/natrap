class FiscalYear
    def initialize(year)
	@year = year
    end

    def year
        @year
    end

    def start_date
        date = Date.new((@year.to_i - 1),10,1)
    end

    def end_date
        date = Date.new(@year.to_i,9,30)
    end

    def self.from_date(input_date_string)
        #Required format mm/dd/yyyy
        #Outputs the fiscal year(string) in which the provided date falls, i.e. FiscalYear.from_date('12/25/2014') => '2015'
        input_date = Date.strptime(input_date_string, '%m/%d/%Y')
        oct1_of_input_year = Date.new(input_date.year,10,01)

       input_date > oct1_of_input_year ?  (input_date.year+1).to_s : input_date.year.to_s
    end

    def self.today
        #Returns the fiscal year(string) for today's date
        self.from_date(Date.today.strftime("%m/%d/%Y"))
    end
end
