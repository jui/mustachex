defmodule Mustachex.Tokenizer do
  @moduledoc false

  def tokenize(template) when is_binary(template) do
    tokenize(String.to_char_list(template))
  end

  def tokenize(template) when is_list(template) do
    scan(template, [], [], :in_text)
  end

  defp scan('{{{' ++ t, scanned, buf, :in_text), do: scan(t, scanned ++ [parse_text(buf)], [], :in_unescaped_var)
  defp scan('}}}' ++ t, scanned, buf, :in_unescaped_var), do: scan(t, scanned ++ [parse_variable(buf, :unescaped)], [], :in_text)
  defp scan('{{' ++ t, scanned, buf, :in_text), do: scan(t, scanned ++ [parse_text(buf)], [], :in_tag)
  defp scan('}}' ++ t, scanned, buf, :in_tag), do: scan(t, scanned ++ [parse_tag(strip(buf))], [], :in_text)
  defp scan([h|t], scanned, buf, scan_type), do: scan(t, scanned, buf ++ [h], scan_type)
  defp scan([], scanned, buf, :in_text), do: scanned ++ [parse_text(buf)]

  defp strip(str), do: :string.strip(str, :both)
  defp is_dotted?(str), do: Enum.member?(str, ?.)

  defp parse_tag('!' ++ _t), do: {}
  defp parse_tag('#' ++ t), do: parse_section(t, :section)
  defp parse_tag('^' ++ t), do: parse_section(t, :inverted_section)
  defp parse_tag('/' ++ t), do: {:end_section, parse_name(t)}
  defp parse_tag('>' ++ t), do: {:partial, parse_name(t), 0}
  defp parse_tag('&' ++ t), do: parse_variable(t, :unescaped)
  defp parse_tag('=' ++ _t), do: {}
  defp parse_tag('.' ++ _t), do: {:dot, :.}
  defp parse_tag(t), do: parse_variable(t, :escaped)

  defp parse_name(str) do
    if is_dotted?(str) do
      :string.tokens(str, '.') |> Enum.map(fn(t) -> List.to_atom(t) end)
    else
      List.to_atom(strip(str))
    end
  end

  defp parse_text(buf), do: {:text, List.to_string(buf)}

  defp parse_section(buf, :section) do
    if is_dotted?(buf) do
      {:dotted_name_section, parse_name(buf)}
    else
      {:section, parse_name(buf)}
    end
  end
  defp parse_section(buf, :inverted_section) do
    if is_dotted?(buf) do
      {:dotted_name_inverted_section, parse_name(buf)}
    else
      {:inverted_section, parse_name(buf)}
    end
  end

  defp parse_variable(buf, :escaped) do
    var = :variable
    if is_dotted?(buf) do
      var = :dotted_name
    end
    {var, parse_name(buf)}
  end
  defp parse_variable(buf, :unescaped) do
    var = :unescaped_variable
    if is_dotted?(buf) do
      var = :unescaped_dotted_name
    end
    {var, parse_name(buf)}
  end

end

