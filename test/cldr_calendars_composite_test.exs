defmodule Cldr.Calendar.Composite.Test do
  use ExUnit.Case
  doctest Cldr.Calendar.Composite

  alias Cldr.Calendar.England

  test "The English calendar has 19 days in September 1752" do
    assert England.days_in_month(1752, 9) == 19
  end

  test "The English calendar has 355 days in 1752" do
    assert England.days_in_year(1752) == 355
  end

  test "The English calendar has 365 days in 1751" do
    assert England.days_in_year(1751) == 365
  end

  test "The English calendar has 365 days in 1753" do
    assert England.days_in_year(1753) == 365
  end

  test "that 1752 is a leap year" do
    assert Cldr.Calendar.England.leap_year?(1752) == true
  end

  test "Valid dates in September 1752 1..2 and 14..30" do
    for d <- 1..2 do
      assert England.valid_date?(1752, 9, d)
    end

    for d <- 14..30 do
      assert England.valid_date?(1752, 9, d)
    end
  end

  test "No valid dates in September 1752 from 3 to 13th" do
    for d <- 3..13 do
      refute England.valid_date?(1752, 9, d)
    end
  end

  test "That 11 days are 'missing' at the transition" do
    last_date_of_old_style = ~D[1752-09-02 Cldr.Calendar.England]
    assert ~D[1752-09-14 Cldr.Calendar.England] == Date.shift(last_date_of_old_style, day: 1)
  end
end
