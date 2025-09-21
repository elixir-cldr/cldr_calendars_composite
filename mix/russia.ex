defmodule Cldr.Calendar.Russia do
  @moduledoc """
  Composite Russian Calendar.

  See:

    https://www.justrussian.com/history-of-new-year-celebrations-in-russia/
    https://en.wikipedia.org/wiki/Byzantine_calendar
    https://en.wikipedia.org/wiki/Julian_calendar

  """
  use Cldr.Calendar.Composite,
    calendars: [

      ~D[1492-09-01 Cldr.Calendar.Julian.Sept1],
      ~D[1700-01-01 Cldr.Calendar.Julian.Jan1],
      ~D[1918-02-14 Cldr.Calendar.Gregorian]
    ],
    base_calendar: Cldr.Calendar.Julian.March1

end