$ ->
  words = $.getJSON("spellings.json")
  $.when(words).done (()->
    alert("Hello World")
    return
  )

  $.when(words).fail((data,status,error) ->
    console.log(status + error)
    return
  )
