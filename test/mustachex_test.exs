Code.require_file "test_helper.exs", __DIR__

defmodule MustachexTest do
  use ExUnit.Case

  test "render simple using lists" do
    assert Mustachex.render("Hello, {{name}}", [name: "Mustache"]) == "Hello, Mustache"
  end

  test "render multi line using lists" do
    assert Mustachex.render("Hello\n{{name}}", [name: "Mustache"]) == "Hello\nMustache"
  end

  test "render with nested context using lists" do
    assert Mustachex.render("{{#a}}{{#b}}Mustache{{/b}}{{/a}}", [a: true, b: true]) == "Mustache"
  end

  test "render nil using lists" do
    assert Mustachex.render("Hello, {{name}}", [name: nil]) == "Hello, "
  end
  test "render missing variable using lists" do
    assert Mustachex.render("Hello, {{name}}", []) == "Hello, "
  end

  test "render unescaped using lists" do
    assert Mustachex.render("{{{string}}}", [string: "&\'\"<>"]) == "&\'\"<>"
  end

  test "render unescaped ampersand using lists" do
    assert Mustachex.render("{{{string}}}", [string: "&\'\"<>"]) == "&\'\"<>"
  end

  test "render escaped using lists" do
    assert Mustachex.render("{{string}}", [string: "&\'\"<>"]) == "&amp;&#39;&quot;&lt;&gt;"
  end

  test "render list using lists" do
    assert Mustachex.render("Hello{{#names}}, {{name}}{{/names}}", [names: [[name: "Mustache"], [name: "Elixir"]]]) == "Hello, Mustache, Elixir"
  end

  test "render list twice using lists" do
    assert Mustachex.render("Hello{{#names}}, {{name}}{{/names}}! Hello{{#names}}, {{name}}{{/names}}!", [names: [[name: "Mustache"], [name: "Elixir"]]]) == "Hello, Mustache, Elixir! Hello, Mustache, Elixir!"
  end

  test "render single value using lists" do
    assert Mustachex.render("Hello{{#person}}, {{name}}{{/person}}!", [person: [name: "Mustache"]]) == "Hello, Mustache!"
  end

  test "render empty list using lists" do
    assert Mustachex.render("{{#things}}something{{/things}}", [things: []]) == ""
  end

  test "render nested list using lists" do
    assert Mustachex.render("{{#x}}{{#y}}{{z}}{{/y}}{{/x}}", [x: [y: [z: "z"]]]) == "z"
  end

  test "render comment using lists" do
    assert Mustachex.render("Hello, {{! comment }}{{name}}", [name: "Mustache"]) == "Hello, Mustache"
  end

  test "render tags with whitespace using lists" do
    assert Mustachex.render("Hello, {{# names }}{{ name }}{{/ names }}", [names: [[name: "Mustache"]]]) == "Hello, Mustache"
  end

  test "render true section using lists" do
    assert Mustachex.render("Hello, {{#bool}}Mustache{{/bool}}", [bool: true]) == "Hello, Mustache"
  end

  test "render false section using lists" do
    assert Mustachex.render("Hello, {{#bool}}Mustache{{/bool}}", [bool: false]) == "Hello, "
  end

  test "render inverted empty list using lists" do
    assert Mustachex.render("{{^things}}Empty{{/things}}", [thins: []]) == "Empty"
  end

  test "render inverted list using lists" do
    assert Mustachex.render("{{^things}}Empty{{/things}}", [things: ["yeah"]]) == ""
  end

  test "render inverted true section using lists" do
    assert Mustachex.render("Hello, {{^bool}}Mustache{{/bool}}", [bool: true]) == "Hello, "
  end

  test "render inverted false section using lists" do
    assert Mustachex.render("Hello, {{^bool}}Mustache{{/bool}}", [bool: false]) == "Hello, Mustache"
  end

  test "render dotted name using lists" do
    assert Mustachex.render("Hello, {{cool.mustache.name}}", [cool: [mustache: [name: "Mustache"]]]) == "Hello, Mustache"
  end

  test "render dotted name section using lists" do
    assert Mustachex.render("Hello, {{#person.name}}Mustache{{/person.name}}", [person: [name: true]]) == "Hello, Mustache"
  end

  test "render dotted name inverted section using lists" do
    assert Mustachex.render("Hello, {{#person.name}}Mustache{{/person.name}}", [people: [names: true]]) == "Hello, "
  end

  test "render implicit iterator using lists" do
    assert Mustachex.render("Hello{{#names}}, {{.}}{{/names}}!", [names: ["Mustache", "Elixir"]]) == "Hello, Mustache, Elixir!"
  end

  test "render lambda using lists" do
    assert Mustachex.render("Hello, {{name}}", [name: fn -> "Mustache" end]) == "Hello, Mustache"
  end

  test "render partial using lists" do
    assert Mustachex.render("Hello, {{>name}}", [n: "Mustache"], partials: [name: "{{n}}"]) == "Hello, Mustache"
  end

  test "render looooong using lists" do
    template = """
    {{! ignore this line! }}
    Hello {{name}}
    {{! ignore this line! }}
    You have just won {{value}} dollars!
    {{#in_ca}}
    Well, {{taxed_value}} dollars, after taxes.
    {{/in_ca}}
    a{{! dont ignore this line! }}
    """

    expected = """

    Hello mururu

    You have just won 1000 dollars!

    Well, 50 dollars, after taxes.

    Well, 40 dollars, after taxes.

    a
    """

    assert Mustachex.render(template, [name: "mururu", value: 1000, in_ca: [[taxed_value: 50], [taxed_value: 40]]]) == expected
  end


  test "render simple using maps" do
    assert Mustachex.render("Hello, {{name}}", %{name: "Mustache"}) == "Hello, Mustache"
  end

  test "render multi line using maps" do
    assert Mustachex.render("Hello\n{{name}}", %{name: "Mustache"}) == "Hello\nMustache"
  end

  test "render with nested context using maps" do
    assert Mustachex.render("{{#a}}{{#b}}Mustache{{/b}}{{/a}}", %{a: true, b: true}) == "Mustache"
  end

  test "render nil using maps" do
    assert Mustachex.render("Hello, {{name}}", %{name: nil}) == "Hello, "
  end
  test "render missing variable using maps" do
    assert Mustachex.render("Hello, {{name}}", %{}) == "Hello, "
  end

  test "render unescaped using maps" do
    assert Mustachex.render("{{{string}}}", %{string: "&\'\"<>"}) == "&\'\"<>"
  end

  test "render unescaped ampersand using maps" do
    assert Mustachex.render("{{{string}}}", %{string: "&\'\"<>"}) == "&\'\"<>"
  end

  test "render escaped using maps" do
    assert Mustachex.render("{{string}}", %{string: "&\'\"<>"}) == "&amp;&#39;&quot;&lt;&gt;"
  end

  test "render list using maps" do
    assert Mustachex.render("Hello{{#names}}, {{name}}{{/names}}", %{names: [%{name: "Mustache"}, %{name: "Elixir"}]}) == "Hello, Mustache, Elixir"
  end

  test "render list twice using maps" do
    assert Mustachex.render("Hello{{#names}}, {{name}}{{/names}}! Hello{{#names}}, {{name}}{{/names}}!", %{names: [%{name: "Mustache"}, %{name: "Elixir"}]}) == "Hello, Mustache, Elixir! Hello, Mustache, Elixir!"
  end

  test "render single value using maps" do
    assert Mustachex.render("Hello{{#person}}, {{name}}{{/person}}!", %{person: %{name: "Mustache"}}) == "Hello, Mustache!"
  end

  test "render empty list using maps" do
    assert Mustachex.render("{{#things}}something{{/things}}", %{things: []}) == ""
  end

  test "render nested list using maps" do
    assert Mustachex.render("{{#x}}{{#y}}{{z}}{{/y}}{{/x}}", %{x: %{y: %{z: "z"}}}) == "z"
  end

  test "render comment using maps" do
    assert Mustachex.render("Hello, {{! comment }}{{name}}", %{name: "Mustache"}) == "Hello, Mustache"
  end

  test "render tags with whitespace using maps" do
    assert Mustachex.render("Hello, {{# names }}{{ name }}{{/ names }}", %{names: [%{name: "Mustache"}]}) == "Hello, Mustache"
  end

  test "render true section using maps" do
    assert Mustachex.render("Hello, {{#bool}}Mustache{{/bool}}", %{bool: true}) == "Hello, Mustache"
  end

  test "render false section using maps" do
    assert Mustachex.render("Hello, {{#bool}}Mustache{{/bool}}", %{bool: false}) == "Hello, "
  end

  test "render inverted empty list using maps" do
    assert Mustachex.render("{{^things}}Empty{{/things}}", %{thins: []}) == "Empty"
  end

  test "render inverted list using maps" do
    assert Mustachex.render("{{^things}}Empty{{/things}}", %{things: ["yeah"]}) == ""
  end

  test "render inverted true section using maps" do
    assert Mustachex.render("Hello, {{^bool}}Mustache{{/bool}}", %{bool: true}) == "Hello, "
  end

  test "render inverted false section using maps" do
    assert Mustachex.render("Hello, {{^bool}}Mustache{{/bool}}", %{bool: false}) == "Hello, Mustache"
  end

  test "render dotted name using maps" do
    assert Mustachex.render("Hello, {{cool.mustache.name}}", %{cool: %{mustache: %{name: "Mustache"}}}) == "Hello, Mustache"
  end

  test "render dotted name section using maps" do
    assert Mustachex.render("Hello, {{#person.name}}Mustache{{/person.name}}", %{person: %{name: true}}) == "Hello, Mustache"
  end

  test "render dotted name inverted section using maps" do
    assert Mustachex.render("Hello, {{#person.name}}Mustache{{/person.name}}", %{people: %{names: true}}) == "Hello, "
  end

  test "render implicit iterator using maps" do
    assert Mustachex.render("Hello{{#names}}, {{.}}{{/names}}!", %{names: ["Mustache", "Elixir"]}) == "Hello, Mustache, Elixir!"
  end

  test "render lambda using maps" do
    assert Mustachex.render("Hello, {{name}}", %{name: fn -> "Mustache" end}) == "Hello, Mustache"
  end

  test "render partial using maps" do
    assert Mustachex.render("Hello, {{>name}}", %{n: "Mustache"}, partials: %{name: "{{n}}"}) == "Hello, Mustache"
  end

  test "render looooong using maps" do
    template = """
    {{! ignore this line! }}
    Hello {{name}}
    {{! ignore this line! }}
    You have just won {{value}} dollars!
    {{#in_ca}}
    Well, {{taxed_value}} dollars, after taxes.
    {{/in_ca}}
    a{{! dont ignore this line! }}
    """

    expected = """

    Hello mururu

    You have just won 1000 dollars!

    Well, 50 dollars, after taxes.

    Well, 40 dollars, after taxes.

    a
    """

    assert Mustachex.render(template, %{name: "mururu", value: 1000, in_ca: [%{taxed_value: 50}, %{taxed_value: 40}]}) == expected
  end
end
