defmodule Cldr.Calendar.Composite.Test do
  use ExUnit.Case
  doctest Cldr.Calendar.Composite

  defmodule England do
    use Cldr.Calendar.Composite,
      calendars: ~D[1752-09-14]
  end

  test "The English calendar has 18 days in September 1752" do
    assert England.days_in_month(1752, 9) == 19
  end

  test "The English calendar has 354 days in 1752" do
    assert England.days_in_year(1752) == 355
  end

  test "The English calendar has 354 days in 1751" do
    assert England.days_in_year(1751) == 365
  end

  test "The English calendar has 354 days in 1753" do
    assert England.days_in_year(1753) == 365
  end

  test "that 1752 is a leap year" do
    assert Cldr.Calendar.England.leap_year?(1752) == true
  end

  test "Valid dates in September 1752 beyond for 1st to 18th" do
    for d <- 1..19 do
      assert England.valid_date?(1752, 9, d)
    end
  end

  test "No valid dates in September 1752 beyond the 18th" do
    for d <- 20..30 do
      refute England.valid_date?(1752, 9, d)
    end
  end
end
