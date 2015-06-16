$ ->
  words = $.getJSON("spellings.json")
  $.when(words).done (()->
    alert("Hello World")
    return
  )

  $.when(words).fail(() ->
    alert("FAIL!")
    return
  )
