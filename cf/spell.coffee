$ ->

  @current = ""

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
    update_keyHandler()
    $("p#hint").empty().append(word['hint'])


  update_keyHandler = () ->
    $("#input_answer").keydown((e) =>
      console.log this.curren
      if e.which == 13
        attempt = $("#input_answer").val()
        if attempt.toLowerCase() == @current.toLowerCase()
          alert("SUCCESS!")
        else
          alert("FAIL!")
    )
