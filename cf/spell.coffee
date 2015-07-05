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
    @reveal = ""
    update_question(data)
    @data = data

  random_question = (data) ->
    choice = Math.floor(Math.random() * data['words'].length)
    @current = data['words'][choice]['name']
    [1..@current.length].forEach ->
      @reveal.concat("_")
    return data['words'][choice]

  update_question = (data) ->
    entry = random_question(data)
    update_keyHandler()
    size = entry.name.length
    $("dd#hint_stat").empty().append("This word is " + size + " letters long.")
    $("dd#hint_define").empty().append(entry['hint'])
    $("dd#hint_sentence").empty().append(entry['example'])

  emptyInput = () ->
    $("input#input_answer").val("")

  randomLetter = () ->
    n = Math.floor(Math.random * @current.length)

  revealLetter = () ->
    i = randomLetter()

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
          if @fail % 2 == 0
            revealLetter()
          $(".alert").empty().append("You have failed " + @fail + last)
          emptyInput()
      )
