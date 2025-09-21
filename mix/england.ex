defmodule Cldr.Calendar.England do
  use Cldr.Calendar.Composite,
    calendars: [
      ~D[1155-03-25 Cldr.Calendar.Julian.March25],
      ~D[1751-03-25 Cldr.Calendar.Julian],
      ~D[1752-09-14 Cldr.Calendar.Gregorian]
      ],
    base_calendar: Cldr.Calendar.Julian
end