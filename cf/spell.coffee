$ ->

  @current = 0

  $("#question, #answer").hide()
  words = $.getJSON("spellings.json")
  $.when(words).done ((d)->
    startUp(d)
  )

  $.when(words).fail((data,status,error) ->
    console.log(status + error)
    return
  )

  startUp = (data) ->
    $("#question, #answer").show()
    update_question(data)

  random_question = (data) ->
    choice = Math.floor(Math.random() * data['words'].length)
    @current = choice
    return data['words'][choice]

  update_question = (data) ->
    word = random_question(data)
    $("p#hint").empty().append(word['hint'])
