defmodule Cldr.Calendar.Composite do
  @moduledoc """
  A composite calendar is one in which a certain range of dates
  is interpreted in one calendar and a different range of dates
  is interpreted in a different calendar.

  The canonical example is the transition from the Julian to
  Gregorian calendar for European countries during the 16th to
  20th centuries.

  A configuration is simply a list of dates in the the
  appropriate calendar indicating when the calendar transitions
  occur.

  For example, assuming England moved from the Julian to
  Gregorian calendar on `14th of September, 1752 Gregorian`
  then the configuration would be:

  ```elixir
  defmodule Cldr.Calendar.England do
    use Cldr.Calendar.Composite,
      calendars: [
        ~D[1752-09-14 Cldr.Calendar.Gregorian]
      ],
      base_calendar: Cldr.Calendar.Julian

  end
  ```

  The `:base_calendar` option indicates the calendar in use
  before any other configured calendars.  The default is
  `Cldr.Calendar.Julian`.

  ### Julian to Gregorian transition

  One of the uses of this calendar is to define a calendar that
  reflects the transition from the Julian to the Gregorian calendar.

  Applicable primarily to western european countries and
  related colonies, the transition to the Gregorian calendar
  occurred between the 16th and 20th centuries. One strong
  reference is the [Perpetual Calendar](https://norbyhus.dk/calendar.php)
  site maintained by [Toke Nørby](mailto:Toke.Norby@Norbyhus.dk).

  An additional source of information is
  [Wikipedia](https://en.wikipedia.org/wiki/Adoption_of_the_Gregorian_calendar).

  ### Multiple compositions

  A more complex example composes more than one calendar. For example,
  Egypt used the [Coptic calendar](https://en.wikipedia.org/wiki/Coptic_calendar)
  from 238 BCE until Rome introduced the Julian calendar in approximately
  30 BCE. The Gregorian calendar was then introduced in 1875. Although the
  exact dates of introduction aren't known we can approximate the composition
  of calendars with:

  ```elixir
  defmodule Cldr.Calendar.Composite.Egypt do
    use Cldr.Calendar.Composite,
      calendars: [
        ~D[-0045-01-01 Cldr.Calendar.Julian],
        ~D[1875-09-01]
      ],
      base_calendar: Cldr.Calendar.Coptic
  end
  ```

  """

  alias Cldr.Calendar.Composite.Config

  defmacro __using__(options \\ []) do
    quote bind_quoted: [options: options] do
      require Cldr.Calendar.Composite.Compiler

      @options options
      @before_compile Cldr.Calendar.Composite.Compiler
    end
  end

  @doc """
  Creates a new composite compiler.

  ## Arguments

  * `calendar_module` is any module name. This will be the
    name of the composite calendar if it is successfully
    created.

  * `options` is a keyword list of options.

  ## Options

  * `:calendars` is a list of dates representing the first
    new date at which a calendar is introduced. These dates
    should be expressed in the calendar of the new period.

  * `:base_calendar` is any calendar module that is used
    as the calendar for any dates prior to the first
    transition. The default is `Cldr.Calendar.Julian`.

  ## Returns

  * `{:ok, module}` or

  * `{:module_already_exists, calendar_module}`

  ## Examples

      iex> Cldr.Calendar.Composite.new Cldr.Calendar.Denmark,
      ...> calendars: ~D[1700-03-01 Cldr.Calendar.Gregorian]
      {:ok, Cldr.Calendar.Denmark}

  """
  @spec new(module(), Keyword.t()) ::
          {:ok, Cldr.Calendar.calendar()} | {:module_already_exists, module()}

  def new(calendar_module, options) when is_atom(calendar_module) and is_list(options) do
    if Code.ensure_loaded?(calendar_module) do
      {:module_already_exists, calendar_module}
    else
      create_calendar(calendar_module, options)
    end
  end

  defp create_calendar(calendar_module, config) do
    with {:ok, config} <- Config.validate_options(config) do
      contents =
        quote do
          use unquote(__MODULE__),
              unquote(Macro.escape(config))
        end

      {:module, module, _, :ok} =
        Module.create(calendar_module, contents, Macro.Env.location(__ENV__))

      {:ok, module}
    end
  end
end
