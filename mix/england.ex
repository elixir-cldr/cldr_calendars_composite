defmodule Cldr.Calendar.England do
  @moduledoc """
  Composite English calendar.

  See:

    https://libguides.ctstatelibrary.org/hg/colonialresearch/calendar
    https://en.wikipedia.org/wiki/Julian_calendar

  """
  use Cldr.Calendar.Composite,
    calendars: [
      ~D[1155-03-25 Cldr.Calendar.Julian.March25],
      ~D[1751-03-25 Cldr.Calendar.Julian.Jan1],
      ~D[1752-09-14 Cldr.Calendar.Gregorian]
      ],
    base_calendar: Cldr.Calendar.Julian
end