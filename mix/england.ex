defmodule Cldr.Calendar.England do
  @moduledoc """
  Composite English calendar.

  See:

    https://libguides.ctstatelibrary.org/hg/colonialresearch/calendar
    https://en.wikipedia.org/wiki/Julian_calendar

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