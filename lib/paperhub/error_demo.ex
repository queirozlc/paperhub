defmodule Paperhub.ErrorDemo do
  def translate_error(error) do
    error
    |> Ash.Error.to_error_class()
    |> Map.get(:errors)
    |> Enum.flat_map(fn error ->
      if AshPhoenix.FormData.Error.impl_for(error) do
        error
        |> AshPhoenix.FormData.Error.to_form_error()
        |> List.wrap()
        |> Enum.map(fn {field, message, vars} ->
          dbg({error, field})
          {Enum.join(error.path ++ [field], "."), replace_vars(message, vars)}
        end)
      else
        []
      end
    end)
  end

  defp replace_vars(message, vars) do
    Enum.reduce(vars || [], message, fn {key, value}, acc ->
      dbg({message, key, value})
      String.replace(acc, "%{#{key}}", to_string(value) |> String.to_atom())
    end)
  end
end
