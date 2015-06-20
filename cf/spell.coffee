$ ->

  @current = ""
  @context = this
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
    @data = data

  random_question = (data) ->
    choice = Math.floor(Math.random() * data['words'].length)
    @current = data['words'][choice]['name']
    return data['words'][choice]

  update_question = (data) ->
    word = random_question(data)
    $("p#hint").empty().append(word['hint'])

  $("#input_answer").keydown((e) =>
    console.log this.current
#    if e.which == 13
#      attempt = $("#input_answer").val()
#      if attempt.toLowerCase() == @choice.toLowerCase()
#        alert("SUCCESS!")
#      else
#        alert("FAIL!")
  )
