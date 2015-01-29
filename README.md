# Mustache for Elixir

[![Build Status](https://travis-ci.org/jui/mustachex.png?branch=master)](https://travis-ci.org/jui/mustachex)

## Usage

```elixir
Mustachex.render("Hello, {{planet}}", [planet: "World!"])
#=> "Hello, World!"
Mustachex.render("Hello, {{planet}}", %{planet: "World!"})
```

## Todo
 * Support for delimiter change

## Links

* [mustache(5) -- Logic-less templates.](http://mustache.github.io/mustache.5.html)
