defmodule Cldr.Calendar.Composite.Compiler do
  defmacro __before_compile__(env) do
    config =
      Module.get_attribute(env.module, :options)
      |> Keyword.put(:calendar, env.module)
      |> Cldr.Calendar.Composite.Config.extract_options()
      |> Macro.escape()

    Module.put_attribute(env.module, :calendar_config, config)

    quote location: :keep, bind_quoted: [config: config, reverse: Enum.reverse(config)] do
      @moduledoc false

      @behaviour Calendar
      @behaviour Cldr.Calendar

      @type year :: -9999..9999
      @type month :: 1..12
      @type day :: 1..31

      @quarters_in_year 4

      import Cldr.Macros
      import Cldr.Calendar.Composite.Config, only: [define_transition_functions: 2]
      alias Cldr.Calendar.Base.Month

      @doc false
      def __config__ do
        @calendar_config
      end

      @doc """
      Identifies that the calendar is month based.

      This may not always be true for all dates
      in a composite calendar but only a single
      value per calndar is supported.

      """
      @impl true
      def calendar_base do
        :month
      end

      @doc """
      Defines the CLDR calendar type for this calendar.

      This type is used in support of `Cldr.Calendar.localize/3`.

      """
      @impl true
      def cldr_calendar_type do
        :gregorian
      end

      @doc """
      Identify the base calendar for a given date.

      This function derives the calendar we delegate
      to for a given date based upon the configuration.

      """
      for {_iso_days, y, m, d, calendar} <- reverse do
        def calendar_for_date(year, month, day)
            when year > unquote(y) or
                   (year >= unquote(y) and month > unquote(m)) or
                   (year >= unquote(y) and month >= unquote(m) and day >= unquote(d)) do
          unquote(calendar)
        end
      end

      @doc """
      Determines if the date given is valid according to this calendar.

      """
      @impl true
      def valid_date?(year, month, day) do
        months_in_year = months_in_year(year)
        days_in_month = days_in_month(year, month)

        year in -9999..9999 and month in 1..months_in_year && day in 1..days_in_month
      end

      @doc """
      Calculates the year and era from the given `year`.
      The ISO calendar has two eras: the current era which
      starts in year 1 and is defined as era "1". And a
      second era for those years less than 1 defined as
      era "0".

      The result is in the context of the calendar
      in effect on the first day of the year.

      """
      @spec year_of_era(year, month, day) :: {year, era :: non_neg_integer}
      @impl true
      def year_of_era(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.year_of_era(year)
      end

      @doc """
      Returns the calendar year as displayed
      on rendered calendars.

      """
      @spec calendar_year(Calendar.year, Calendar.month, Calendar.day) :: Calendar.year()
      @impl true
      def calendar_year(year, month, day) do
        year
      end

      @doc """
      Returns the related gregorain year as displayed
      on rendered calendars.

      """
      @spec related_gregorian_year(Calendar.year, Calendar.month, Calendar.day) :: Calendar.year()

      @impl true
      def related_gregorian_year(year, month, day) do
        year
      end

      @doc """
      Returns the extended year as displayed
      on rendered calendars.

      """
      @spec extended_year(Calendar.year, Calendar.month, Calendar.day) :: Calendar.year()

      @impl true
      def extended_year(year, month, day) do
        year
      end

      @doc """
      Returns the cyclic year as displayed
      on rendered calendars.

      """
      @spec cyclic_year(Calendar.year, Calendar.month, Calendar.day) :: Calendar.year()

      @impl true
      def cyclic_year(year, month, day) do
        year
      end

      @doc """
      Calculates the quarter of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 4.

      """
      @spec quarter_of_year(year, month, day) :: 1..4
      @impl true
      def quarter_of_year(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.quarter_of_year(year, month, day)
      end

      @doc """
      Calculates the month of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 12.

      """
      @spec month_of_year(year, month, day) :: month
      @impl true
      def month_of_year(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.month_of_year(year, month, day)
      end

      @doc """
      Calculates the week of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 53.

      """
      @spec week_of_year(year, month, day) :: {year, Cldr.Calendar.week()}
      @impl true
      def week_of_year(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.week_of_year(year, month, day)
      end

      @doc """
      Calculates the ISO week of the year from the given `year`, `month`, and `day`.
      It is an integer from 1 to 53.

      """
      @spec iso_week_of_year(year, month, day) :: {year, Cldr.Calendar.week()}
      @impl true
      def iso_week_of_year(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.iso_week_of_year(year, month, day)
      end

      @doc """
      Calculates the week of the month from the given `year`, `week`, and `day`.
      It is an integer from 1 to 5.

      """
      @spec week_of_month(year, Cldr.Calendar.week(), day) :: {:error, :not_defined}
      @impl true
      def week_of_month(year, week, day) do
        {:error, :not_defined}
      end

      @doc """
      Calculates the day and era from the given `year`, `month`, and `day`.

      """
      @spec day_of_era(year, month, day) :: {day :: non_neg_integer(), era :: non_neg_integer}
      @impl true
      def day_of_era(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.day_of_era(year, month, day)
      end

      @doc """
      Calculates the day of the year from the given `year`, `month`, and `day`.

      """
      @spec day_of_year(year, month, day) :: 1..366
      @impl true
      def day_of_year(year, month, day) do
        calendar = calendar_for_date(year, month, day)
        calendar.day_of_year(year, month, day)
      end

      @doc """
      Calculates the day of the week from the given `year`, `month`, and `day`.
      It is an integer from 1 to 7, where 1 is Monday and 7 is Sunday.

      """
      if Code.ensure_loaded?(Date) and function_exported?(Date, :day_of_week, 2) do
        @spec day_of_week(year, month, day, :default) ::
          {Calendar.day_of_week(), first_day_of_week :: non_neg_integer(), last_day_of_week :: non_neg_integer()}
        @impl true
        def day_of_week(year, month, day, :default) do
          calendar = calendar_for_date(year, month, day)
          calendar.day_of_week(year, month, day)
        end
      else
        @spec day_of_week(year, month, day) :: 1..7
        @impl true
        def day_of_week(year, month, day) do
          calendar = calendar_for_date(year, month, day)
          calendar.day_of_week(year, month, day)
        end
      end

      @doc """
      Calculates the number of period in a given `year`. A period
      corresponds to a month in month-based calendars and
      a week in week-based calendars..

      """
      @impl true
      def periods_in_year(year) do
        months_in_year(year)
      end

      @doc """
      Returns the number days in a given year.

      """
      @spec days_in_year(year) :: Calendar.day()
      @impl true
      def days_in_year(year) do
        months_in_year = months_in_year(year)
        starts = date_to_iso_days(year, 1, 1)
        ends = date_to_iso_days(year, months_in_year, days_in_month(year, months_in_year))

        ends - starts + 1
      end

      @doc """
      Returns the number weeks in a given year.

      The result is returned in the context of the
      calendar that starts the year.

      """
      @spec weeks_in_year(year) :: Calendar.week()
      @impl true
      def weeks_in_year(year) do
        calendar = calendar_for_date(year, 1, 1)
        calendar.weeks_in_year(year)
      end

      @doc """
      Returns how many days there are in the given year-month.

      """
      @spec days_in_month(year, month) :: Calendar.day()
      @impl true
      define_transition_functions(config, fn
        # Transitions from one calendar to another
        {_, old_year, old_month, _, old_calendar}, [{_, new_year, new_month, _, new_calendar} | _] ->
          [
            def days_in_month(year, month)
                when year == unquote(new_year) and month == unquote(new_month) do
              starts = date_to_iso_days(year, month, 1)

              ends =
                date_to_iso_days(year, month, unquote(new_calendar).days_in_month(year, month))

              ends - starts + 1
            end,

            # Months and years earlier than the transition
            def days_in_month(year, month)
                when (year == unquote(old_year) and month >= unquote(old_month)) or
                       year >= unquote(old_year) do
              unquote(old_calendar).days_in_month(year, month)
            end
          ]

        # All other months after the final transition
        {_, _, _, _, calendar}, [] ->
          def days_in_month(year, month) do
            unquote(calendar).days_in_month(year, month)
          end
      end)

      @doc """
      Returns how many days there are in the given month.

      Must be implemented in derived calendars because
      we cannot know what the calendar format is.

      """
      @spec days_in_month(Calendar.month) :: Calendar.month() | {:ambiguous, Range.t() | [pos_integer()]} | {:error, :undefined}
      @impl true

      def days_in_month(_month) do
        {:error, :undefined}
      end

      @doc """
      Returns the number days in a a week.

      """
      def days_in_week do
        Month.days_in_week()
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given year.

      """
      @impl true
      def year(year) do
        last_month = months_in_year(year)
        days_in_last_month = days_in_month(year, last_month)

        {:ok, starts} = Date.new(year, 1, 1, __MODULE__)
        {:ok, ends} = Date.new(year, last_month, days_in_last_month)

        Date.range(starts, ends)
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given quarter of a year.

      """
      @impl true
      def quarter(year, quarter) do
        months_in_quarter = div(months_in_year(year), @quarters_in_year)
        starting_month = months_in_quarter * (quarter - 1) + 1
        starting_day = 1

        ending_month = starting_month + months_in_quarter - 1
        ending_day = days_in_month(year, ending_month)

        with {:ok, start_date} <- Date.new(year, starting_month, starting_day, __MODULE__),
             {:ok, end_date} <- Date.new(year, ending_month, ending_day, __MODULE__) do
          Date.range(start_date, end_date)
        end
      end

      @doc """
      Returns a `Date.Range.t` representing
      a given month of a year.

      """

      @impl true
      define_transition_functions(config, fn
        # Transitions from one calendar to another
        {_, old_year, old_month, _, old_calendar}, [{_, new_year, new_month, _, new_calendar} | _] ->
          # Month of transition
          [
            def month(year, month)
                when year == unquote(new_year) and month == unquote(new_month) do
              last_day = unquote(new_calendar).days_in_month(year, month)
              {:ok, starts} = Date.new(year, month, 1, __MODULE__)
              {:ok, ends} = Date.new(year, month, last_day, __MODULE__)

              Date.range(starts, ends)
            end,

            # Months and years earlier than the transition
            def month(year, month)
                when (year == unquote(old_year) and month >= unquote(old_month)) or
                       year >= unquote(old_year) do
              unquote(old_calendar).month(year, month)
            end
          ]

        # All other months after the final transition
        {_, _, _, _, calendar}, [] ->
          def month(year, month) do
            unquote(calendar).month(year, month)
          end
      end)

      @doc """
      Returns a `Date.Range.t` representing
      a given week of a year.

      Not all calendars define weeks and therefore
      the error `{:error, :not_defined}` may
      be returned.

      The `Cldr.Calendar.Julian` does not define
      weeks.

      """
      @impl true
      def week(year, week) do
        base_calendar = calendar_for_date(year, 1, 1)

        case base_calendar.week(year, week) do
          %Date.Range{first_in_iso_days: first_days, last_in_iso_days: last_days} ->
            {y1, m1, d1} = date_from_iso_days(first_days)
            {y2, m2, d2} = date_from_iso_days(last_days)

            {:ok, starts} = Date.new(y1, m1, d1, __MODULE__)
            {:ok, ends} = Date.new(y2, m2, d2, __MODULE__)

            Date.range(starts, ends)

          other ->
            other
        end
      end

      @doc """
      Adds an `increment` number of `date_part`s
      to a `year-month-day`.

      `date_part` can be `:years`, `:quarters`
      or :months`.

      """
      @impl true
      def plus(year, month, day, date_part, increment, options \\ [])

      def plus(year, month, day, :years, years, options) do
        calendar = calendar_for_date(year, month, day)
        calendar.plus(year, month, day, :years, years, options)
      end

      def plus(year, month, day, :quarters, quarters, options) do
        calendar = calendar_for_date(year, month, day)
        calendar.plus(year, month, day, :quarters, quarters, options)
      end

      def plus(year, month, day, :months, months, options) do
        calendar = calendar_for_date(year, month, day)
        calendar.plus(year, month, day, :months, months, options)
      end

      @doc """
      Adds :year, :quarter, :month, :week increments

      These functions support CalendarInterval

      """
      def add(year, month, day, hour, minute, second, microsecond, :year, step) do
        {year, month, day} = plus(year, month, day, :years, step)
        {year, month, day, hour, minute, second, microsecond}
      end

      def add(year, month, day, hour, minute, second, microsecond, :quarter, step) do
        {year, month, day} = plus(year, month, day, :quarters, step)
        {year, month, day, hour, minute, second, microsecond}
      end

      def add(year, month, day, hour, minute, second, microsecond, :month, step) do
        {year, month, day} = plus(year, month, day, :months, step)
        {year, month, day, hour, minute, second, microsecond}
      end

      @doc """
      Returns if the given year is a leap year.

      The result is in the context of the calendar
      in effect on the first day of the year.

      """
      @spec leap_year?(year) :: boolean()
      @impl true

      def leap_year?(year) do
        calendar = calendar_for_date(year, 1, 1)
        calendar.leap_year?(year)
      end

      @doc """
      Returns the number of days since the calendar
      epoch for a given `year-month-day`

      """
      for {_iso_days, y, m, d, calendar} <- reverse do
        def date_to_iso_days(year, month, day)
            when year > unquote(y) or
                   (year >= unquote(y) and month > unquote(m)) or
                   (year >= unquote(y) and month >= unquote(m) and day >= unquote(d)) do
          unquote(calendar).date_to_iso_days(year, month, day)
        end
      end

      @doc """
      Returns `{year, month, day}` calculated from
      the number of `iso_days`.

      """
      for {transition_iso_days, _year, _month, _day, calendar} <- reverse do
        def date_from_iso_days(iso_days) when iso_days >= unquote(transition_iso_days) do
          unquote(calendar).date_from_iso_days(iso_days)
        end
      end

      @doc """
      Returns the `t:Calendar.iso_days/0` format of the specified date.

      """
      @impl true
      @spec naive_datetime_to_iso_days(
              Calendar.year(),
              Calendar.month(),
              Calendar.day(),
              Calendar.hour(),
              Calendar.minute(),
              Calendar.second(),
              Calendar.microsecond()
            ) :: Calendar.iso_days()

      def naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond) do
        iso_days = date_to_iso_days(year, month, day)
        day_fraction = time_to_day_fraction(hour, minute, second, microsecond)
        {iso_days, day_fraction}
      end

      @doc """
      Converts the `t:Calendar.iso_days/0` format to the datetime format specified by this calendar.

      """
      @spec naive_datetime_from_iso_days(Calendar.iso_days()) :: {
              Calendar.year(),
              Calendar.month(),
              Calendar.day(),
              Calendar.hour(),
              Calendar.minute(),
              Calendar.second(),
              Calendar.microsecond()
            }
      @impl true
      def naive_datetime_from_iso_days({days, day_fraction}) do
        {year, month, day} = date_from_iso_days(days)
        {hour, minute, second, microsecond} = time_from_day_fraction(day_fraction)
        {year, month, day, hour, minute, second, microsecond}
      end

      @doc false
      @impl true
      def date_to_string(year, month, day) do
        Calendar.ISO.date_to_string(year, month, day)
      end

      @doc false
      @impl true
      def datetime_to_string(
            year,
            month,
            day,
            hour,
            minute,
            second,
            microsecond,
            time_zone,
            zone_abbr,
            utc_offset,
            std_offset
          ) do
        Calendar.ISO.datetime_to_string(
          year,
          month,
          day,
          hour,
          minute,
          second,
          microsecond,
          time_zone,
          zone_abbr,
          utc_offset,
          std_offset
        )
      end

      @doc false
      @impl true
      def naive_datetime_to_string(year, month, day, hour, minute, second, microsecond) do
        Calendar.ISO.naive_datetime_to_string(year, month, day, hour, minute, second, microsecond)
      end

      @doc false
      calendar_impl()

      def parse_date(string) do
        Cldr.Calendar.Parse.parse_date(string, __MODULE__)
      end

      @doc false
      calendar_impl()

      def parse_utc_datetime(string) do
        Cldr.Calendar.Parse.parse_utc_datetime(string, __MODULE__)
      end

      @doc false
      calendar_impl()

      def parse_naive_datetime(string) do
        Cldr.Calendar.Parse.parse_naive_datetime(string, __MODULE__)
      end

       if Code.ensure_loaded?(Calendar.ISO) && function_exported?(Calendar.ISO, :parse_time, 1) do
        @doc false
        @impl Calendar
        defdelegate parse_time(string), to: Calendar.ISO
      end

      if Code.ensure_loaded?(Calendar.ISO) && function_exported?(Calendar.ISO, :iso_days_to_beginning_of_day, 1) do
        @doc false
        @impl Calendar
        defdelegate iso_days_to_beginning_of_day(iso_days), to: Calendar.ISO

        @doc false
        @impl Calendar
        defdelegate iso_days_to_end_of_day(iso_days), to: Calendar.ISO
      end

      @doc false
      @impl Calendar
      defdelegate day_rollover_relative_to_midnight_utc, to: Calendar.ISO

      @doc false
      @impl Calendar
      defdelegate months_in_year(year), to: Calendar.ISO

      @doc false
      @impl Calendar
      defdelegate time_from_day_fraction(day_fraction), to: Calendar.ISO

      @doc false
      @impl Calendar
      defdelegate time_to_day_fraction(hour, minute, second, microsecond), to: Calendar.ISO

      @doc false
      @impl Calendar
      defdelegate time_to_string(hour, minute, second, microsecond), to: Calendar.ISO

      @doc false
      @impl Calendar
      defdelegate valid_time?(hour, minute, second, microsecond), to: Calendar.ISO
    end
  end
end
