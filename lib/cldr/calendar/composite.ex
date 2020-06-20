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





  """
  @spec new(module(), Keyword.t()) ::
          {:ok, Cldr.Calendar.calendar()} | {:module_already_exists, module()}

  def new(calendar_module, config) when is_atom(calendar_module) and is_list(config) do
    if Code.ensure_loaded?(calendar_module) do
      {:module_already_exists, calendar_module}
    else
      create_calendar(calendar_module, config)
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
