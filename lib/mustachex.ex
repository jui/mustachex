defmodule Mustachex do
  @moduledoc """
  Mustache is a logic-less templates.
  See [mustache(5) -- Logic-less templates.](http://mustache.github.io/mustache.5.html) for more details
  """

  @doc """
  Get a string `source` and evaluate the values using the `bindings`.
  This is an alias of `Mustachex.render_string`.

  ## Examples

      Mustachex.render "Hello, {{name}}", [name: "Mustache"]
      #=> "Hello, Mustache!"

  """
  def render(source, bindings \\ [], options \\ []) do
    render_string(source, bindings, options)
  end

  @doc """
  Get a string `source` and evaluate the values using the `bindings`.

  ## Examples

      Mustachex.render_string "Hello, {{name}}!", [name: "Mustache"]
      #=> "Hello, Mustache!"

  """
  def render_string(source, bindings \\ [], options \\ []) do
    compiled = compile_string(source, bindings, options)
#    do_eval(compiled, bindings, options)
  end

  @doc """
  Get a `filename` and evaluate the values using the `bindings`.

  ## Examples

      # hello.mustache
      Hello, {{name}}!

      # iex
      Mustachex.render_file "hello.mustache", [name: "Mustache"]
      #=> "Hello, Mustache!"

  """
  def render_file(filename, bindings \\ [], options \\ []) do
    render_string(File.read!(filename), bindings, options)
  end

  @doc """
  Get a string `source` and generate a quoted expression.
  """
  def compile_string(source, bindings, options \\ []) do
    Mustachex.Compiler.compile(source, bindings, options)
  end


#  defp to_context(bindings) do
#    [mustache_root: [bindings]]
#  end

#  defp do_eval(compiled, bindings, options) do
#    { result, _ } = Code.eval_quoted(compiled, to_context(bindings), options)
#    result
#  end
end
