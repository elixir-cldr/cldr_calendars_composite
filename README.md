# Cldr Composite Calendars

Most calendar implementations in computer software implement the [Proleptic Gregorian Calendar](https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar) which projects the [Gregorian Calendar](https://en.wikipedia.org/wiki/Gregorian_calendar) backwards before its introduction starting in 1582.  In general use today this is acceptable since it is not common to be working with dates prior to this period.

However for certain fields of study, the proleptic calendar is misleading. A letter or document dated in 1751 in England would be a date in the [Julian Calendar](https://en.wikipedia.org/wiki/Julian_calendar) since the Gregorian calendar wasn't introduced in England and its colonies until September 14th, 1752. This results in dates being 11 days later in the Gregorian calendar at this time compared with the Julian calendar.

Calendars defined with this library support composing multiple calendars that are implemented for different time periods. While multiple calendars can be composed, the primary use case is to compose calendars that represent a continuum from the Julian calendar to the Gregorian calendar.

Calendars defined with this library implement the `Calendar` behaviour and the `Cldr.Calendar` behaviour defined in the library [ex_cldr_calendars](https://hex.pm/packages/ex_cldr_calendars). See `Cldr.Calendar` for further information.

## Defining a Composite Calendar

A composite calendar is definted as a series of compositions reprenting the transition from one calendar to another. For the example of the transition from Julian to Gregorian calendar in England the first date of the Gregorian calendar is September 14th, 1752.

```elixir
defmodule England do
  use Cldr.Calendar.Composite,
    calendars: ~D[1752-09-14],
    base_calendar: Cldr.Calendar.Julian
end
```

This configuration states that September 14th, 1752 is the first day in the Gregorian calendar. The `:base_calendar` defines the calendar in use before any other composed calendar.  Since `Cldr.Calendar.Julian` is the default `:base_calendar`, this option may be ommitted resulting in the following configuration:

```elixir
defmodule England do
  use Cldr.Calendar.Composite,
    calendars: ~D[1752-09-14]
end
```

It is also possible to define new composite calendars at runtime as well:
```elixir
iex> Cldr.Calendar.Composite.new France, calendars: ~D[1582-12-20]
{:ok, France}
```

A more complex example composes more than one calendar. For example, Egypt used the [Coptic calendar](https://en.wikipedia.org/wiki/Coptic_calendar) from 238 BCE until Rome introduced the Julian calendar in approximately 30 BCE. The Gregorian calendar was then introduced in 1875. Although the exact dates of introduction aren't known we can approximate the composition of calendars with:

```elixir
defmodule Cldr.Calendar.Composite.new Egypt do
  use Cldr.Calendar.Composite,
    calendars: [
      ~D[-0045-01-01 Cldr.Calendar.Julian],
      ~D[1875-09-01]
    ],
    base_calendar: Cldr.Calendar.Coptic
end
```

## Installation

Add `cldr_calendars_composite` to your list of dependencies in `mix.exs`.

```elixir
def deps do
  [
    {:cldr_calendars_composite, "~> 0.1.0"}
  ]
end
```

Documentation is published at [https://hexdocs.pm/cldr_calendars_composite](https://hexdocs.pm/cldr_calendars_composite).

