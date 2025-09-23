defmodule Cldr.Calendar.Transition.Test do
  use ExUnit.Case, async: true

  test "December 31, 1750 is followed by January 1, 1750" do
    assert ~D[1750-01-01 Cldr.Calendar.England] ==
      Date.shift(~D[1750-12-31 Cldr.Calendar.England], day: 1)
  end

  test "March 24, 1750 is followed by March 25, 1751" do
    assert ~D[1751-03-25 Cldr.Calendar.England] ==
      Date.shift(~D[1750-03-24 Cldr.Calendar.England], day: 1)
  end

  test "December 31, 1751 is followed by January 1, 1752" do
    assert ~D[1752-01-01 Cldr.Calendar.England] ==
      Date.shift(~D[1751-12-31 Cldr.Calendar.England], day: 1)
  end

  test "September 2, 1752 is followed by September 14, 1752" do
    assert ~D[1752-09-14 Cldr.Calendar.England] ==
      Date.shift(~D[1752-09-02 Cldr.Calendar.England], day: 1)
  end

end