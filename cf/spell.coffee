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
    @unfinished = []
    update_question(data)
    @data = data

  random_question = (data) ->
    choice = Math.floor(Math.random() * data['words'].length)
    @current = data['words'][choice]['name']
    [1..@current.length].forEach ->
      @reveal = @reveal.concat("_")
    @unfinished = [0..@current.length - 1]
    return data['words'][choice]

  update_question = (data) ->
    entry = random_question(data)
    update_keyHandler()    
    word_count = entry.name.split(" ").length
    size = entry.name.length
    $("dd#hint_stat").empty().append("This word is " + size + " letters long.")
    $("dd#hint_define").empty().append(entry['hint'])
    $("dd#hint_sentence").empty().append(entry['example'])

  emptyInput = () ->
    $("input#input_answer").val("")

  randomLetter = () ->
    if @reveal == @current
      return
    decide = Math.floor(Math.random() * @unfinished.length)
    n = @unfinished[decide]
    @reveal = @reveal.substring(0,n) + @current[n] + @reveal.substring(n + 1)
    @unfinished.splice(decide,1)

  update_keyHandler = () ->
    $("#input_answer").off()
    $("#input_answer").keydown((e) =>
      if e.which == 13
        attempt = $("#input_answer").val()
        if attempt.toLowerCase() == @current.toLowerCase()
          $(".alert").addClass("alert-success")
          $(".alert").empty().append("You had just spelt the word " + @current + " right!")
          $("#revealed").empty()
          @reveal = ""
          update_question(@data)
          emptyInput()
        else
          @fail += 1
          $(".alert").addClass("alert-danger")
          if @fail > 1
            last = " times."
          else
            last = " time."
          randomLetter()
          $("#revealed").empty().append(@reveal)
          $(".alert").empty().append("You have failed " + @fail + last)
          emptyInput()
      )
