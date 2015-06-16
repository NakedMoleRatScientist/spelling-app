$ ->

  words = $.getJSON("spellings.json")
  $.when(words).then (()->
    alert("Hello World")
  )
