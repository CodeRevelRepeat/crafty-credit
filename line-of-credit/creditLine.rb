require 'date'

class LineOfCredit
  attr_accessor :apr, :creditLimit, :principal, :interest, :ledger
  
  def initialize(apr, creditLimit)
    @apr = apr
    @creditLimit = creditLimit
    @principal = 0
    @interest = 0
    @ledger = []
  end
  
  def payment(amount, transactionDate=Time.now)
    if amount <= @interest  
      @interest -= amount
      add_to_ledger("Payment", amount, transactionDate)
    elsif amount <= @interest + @principal
      @principal -= amount - @interest
      @interest = 0
      add_to_ledger("Payment", amount, transactionDate)
    else
      @total = @principal + @interest 
      amount -= @total
      @principal = 0
      @interest = 0
      puts "You made an overpayment.  We are returning $#{amount} to you."
      add_to_ledger("Payment", @total, transactionDate)
    end
  end

  def draw(amount, transactionDate=Time.now)
    if amount > @creditLimit
      puts "Inadequate funds!  You only have $#{@creditLimit} of credit remaining"
    else
      @creditLimit -= amount
      @principal += amount
      puts "You have $#{@creditLimit} of credit remaining"
      add_to_ledger("Draw", amount, transactionDate)
    end
  end

  def add_to_ledger(transactionType, amount, transactionDate)
    @ledger << { "Transaction Type" => transactionType, 
      "Amount" => amount, 
      "Principal Outstanding" => @principal,
      "Transaction Date" => transactionDate}
  end
  
  def charge_interest
    if Time.now.mday === 30
      @accrued_interest = calculate_interest
      @interest += @accrued_interest
      add_to_ledger("Charge Interest", @accrued_interest)
    else
      puts "Interest is only charged on the 30th of each month."
    end
  end

  def calculate_interest(calculationDate=Time.now.to_date)
    @charge_amount = 0
    @tracking_balance = @principal
    @tracking_date = calculationDate
    @ledger.reverse_each do |transaction|
      @num_days = (@tracking_date - transaction["Transaction Date"].to_date).round
      @tracking_balance = transaction["Principal Outstanding"]
      if transaction["Transaction Type"] === "Charge Interest"
        @charge_amount += @tracking_balance * @apr/365 * @num_days
        break
      else
        @charge_amount += @tracking_balance * @apr/365 * @num_days
        @tracking_date = transaction["Transaction Date"].to_date
      end
    end
    @charge_amount.round(2)
  end

  def calculate_payoff_amount(calculationDate)
    @accrued_interest = calculate_interest(calculationDate)
    @principal + @interest + @accrued_interest
  end   
  
  def show_ledger
    puts @ledger
  end
end




