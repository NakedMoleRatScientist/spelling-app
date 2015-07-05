$ ->

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
    @current = ""
    @fail = 0
    update_question(data)
    @data = data

  random_question = (data) ->
    choice = Math.floor(Math.random() * data['words'].length)
    @current = data['words'][choice]['name']
    return data['words'][choice]

  update_question = (data) ->
    word = random_question(data)
    update_keyHandler()
    size = word.name.length
    $("dd#hint_stat").empty().append("This word is " + size + " long.")
    $("dd#hint_define").empty().append(word['hint'])
    $("dd#hint_sentence").empty().append(word['example'])

  emptyInput = () ->
    $("input#input_answer").val("")

  update_keyHandler = () ->
    $("#input_answer").off()
    $("#input_answer").keydown((e) =>
      if e.which == 13
        attempt = $("#input_answer").val()
        if attempt.toLowerCase() == @current.toLowerCase()
          $(".alert").addClass("alert-success")
          $(".alert").empty().append("You had just spelt the word " + @current + " right!")
          update_question(@data)
          emptyInput()
        else
          @fail += 1
          $(".alert").addClass("alert-danger")
          if @fail > 1
            last = " times."
          else
            last = " time."
          $(".alert").empty().append("You have failed " + @fail + last)
          emptyInput()
      )
