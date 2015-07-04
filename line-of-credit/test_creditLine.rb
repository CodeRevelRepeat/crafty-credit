require "./creditLine"
require "test/unit"

class TestCreditLine < Test::Unit::TestCase

  def setup
    @scenario1 = LineOfCredit.new(0.35, 1000)
    @scenario2 = LineOfCredit.new(0.35, 1000)
  end

  def test_draws
    @scenario1.draw(500)
    assert_equal(500, @scenario1.creditLimit)
    assert_equal(500, @scenario1.principal)
    assert_equal(0, @scenario1.interest)
    assert_equal(1, @scenario1.ledger.length)
    assert_equal("Draw", @scenario1.ledger[0]["Transaction Type"])
  end
  
  def test_payments
    @scenario2.draw(500)
    @scenario2.payment(200)
    assert_equal(300, @scenario2.principal)
    assert_equal(0, @scenario2.interest)
    assert_equal(2, @scenario2.ledger.length)
    assert_equal("Payment", @scenario2.ledger[1]["Transaction Type"])
  end

  def test_calculate_interest
    @scenario1.draw(500)
    @testDate1 = @scenario1.ledger[0]["Transaction Date"].to_date + 30
    @scenario2.draw(500)
    @paymentDate = @scenario2.ledger[0]["Transaction Date"].to_date + 15
    @scenario2.payment(200, @paymentDate)
    @secondDrawDate = @scenario2.ledger[0]["Transaction Date"].to_date + 25
    @scenario2.draw(100, @secondDrawDate)
    @testDate2 = @scenario2.ledger[0]["Transaction Date"].to_date + 30
    assert_equal(14.38, @scenario1.calculate_interest(@testDate1))
    assert_equal(11.99, @scenario2.calculate_interest(@testDate2))
  end
  
  def test_calculate_payoff_amount 
    @scenario1.draw(500)
    @testDate1 = @scenario1.ledger[0]["Transaction Date"].to_date + 30
    @scenario2.draw(500)
    @paymentDate = @scenario2.ledger[0]["Transaction Date"].to_date + 15
    @scenario2.payment(200, @paymentDate)
    @secondDrawDate = @scenario2.ledger[0]["Transaction Date"].to_date + 25
    @scenario2.draw(100, @secondDrawDate)
    @testDate2 = @scenario2.ledger[0]["Transaction Date"].to_date + 30
    assert_equal(514.38, @scenario1.calculate_payoff_amount(@testDate1))
    assert_equal(411.99, @scenario2.calculate_payoff_amount(@testDate2))
  end
end

