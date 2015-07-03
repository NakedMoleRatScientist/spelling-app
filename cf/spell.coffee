$ ->

  @current = ""
  @fail = 0

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
    $("p#hint_define").empty().append(word['hint'])
    $("p#hint_sentence").empty().append(word['example'])


  update_keyHandler = () ->
    $("#input_answer").off()
    $("#input_answer").keydown((e) =>
      if e.which == 13
        attempt = $("#input_answer").val()
        if attempt.toLowerCase() == @current.toLowerCase()
          alert("SUCCESS!")
          update_question(@data)
        else
          @fail += 1
          $(".alert").addClass("alert-danger")
          $(".alert").append("You have failed " + @fail)
          $("input#input_answer").val("")
    )
