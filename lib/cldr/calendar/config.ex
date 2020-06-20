defmodule Cldr.Calendar.Composite.Config do
  @moduledoc false

  @default_base_calendar Cldr.Calendar.Julian
  @default_base_date Macro.escape(~D[-9999-01-01 Cldr.Calendar.Julian])

  @doc false
  # Return a list of dates representing calendar transitions
  # in order.
  #
  # Prepends an origin date in a base calendar. THe default
  # base calendar is `Cldr.Calendar.Julian`.

  def extract_options([]) do
    {:error, :no_calendars_configured}
  end

  def extract_options(options) do
    {default_base_date, _} = Code.eval_quoted(@default_base_date)
    base_calendar = Keyword.get(options, :base_calendar, @default_base_calendar)
    base_transition = Map.put(default_base_date, :calendar, base_calendar)

    options
    |> Keyword.get(:calendars)
    |> List.insert_at(0, base_transition)
    |> collect_dates!
  end

  @doc false
  def validate_options([]) do
    {:error, :no_calendars_configured}
  end

  def validate_options(options) when is_list(options) do
    with {:ok, calendars} <- Keyword.fetch(options, :calendars) do
      calendars = if is_list(calendars), do: calendars, else: [calendars]

      all_dates? =
        Enum.all?(calendars, fn
          unquote(Cldr.Calendar.date()) -> calendar
          _other -> false
        end)

      if all_dates? do
        {:ok, Keyword.put(options, :calendars, calendars)}
      else
        {:error, :must_be_a_list_of_dates}
      end
    end
  end

  # Assert we have a lit of dates and then return
  # then in order

  defp collect_dates!(calendars) when is_list(calendars) do
    Enum.map(calendars, fn date ->
      case date do
        unquote(Cldr.Calendar.date()) = date ->
          calendar = if calendar == Calendar.ISO, do: Cldr.Calendar.Gregorian, else: calendar

          {calendar.date_to_iso_days(date.year, date.month, date.day), date.year, date.month,
           date.day, calendar}

        other ->
          raise ArgumentError, "Unknown date found: #{inspect(other)}"
      end
    end)
    |> Enum.sort_by(&elem(&1, 0))
  end

  @doc false
  # This is a form of Enum.reduce which passes the head *and*
  # the tail to the function. Here used so that accumlation is
  # abstracted from the calling function
  def define_transition_functions(list, fun) do
    Cldr.Enum.reduce_peeking(list, [], fn head, tail, acc ->
      result = fun.(head, tail)
      if is_list(result), do: result, else: [result]
      {:cont, acc ++ result}
    end)
  end
end
