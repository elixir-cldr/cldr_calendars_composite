defmodule Cldr.Calendar.England do
  @moduledoc """
  Composite English calendar.

  See:

    https://www.legislation.gov.uk/apgb/Geo2/24/23#commentary-c918471
    https://libguides.ctstatelibrary.org/hg/colonialresearch/calendar
    https://en.wikipedia.org/wiki/Julian_calendar
    https://www.amazon.com.au/Handbook-Dates-Students-British-History/dp/052177845X

  Tax Year:

    https://www.taxadvisorypartnership.com/tax-compliance/why-does-the-uk-tax-year-start-on-6-april-each-year#:~:text=The%20Treasury%2C%20never%20one%20to,25%20March%20to%205%20April.

  Shakespeare:

    Parish Register of Holy Trinity Church, Stratford-upon-Avon April 26, 1564
    https://shakespearedocumented.folger.edu/resource/document/parish-register-entry-recording-william-shakespeares-baptism

    Parish Register of Holy Trinity Church, Stratford-upon-Avon April 25, 1616
    https://shakespearedocumented.folger.edu/resource/document/parish-register-entry-recording-william-shakespeares-burial

    Asimov's Guide to Shakespeare
    https://www.amazon.com.au/Asimovs-Guide-Shakespeare-Isaac-Asimov/dp/0517268256


  """
  use Cldr.Calendar.Composite,
    calendars: [
      ~D[1155-03-25 Cldr.Calendar.Julian.March25],
      ~D[1751-03-25 Cldr.Calendar.Julian.Jan1],
      ~D[1752-09-14 Cldr.Calendar.Gregorian]
      ],
    base_calendar: Cldr.Calendar.Julian

end