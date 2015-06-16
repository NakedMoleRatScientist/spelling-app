$ ->
  words = $.getJSON("spellings.json")
  $.when(words).done ((d)->
    d['words']
  )

  $.when(words).fail((data,status,error) ->
    console.log(status + error)
    return
  )
