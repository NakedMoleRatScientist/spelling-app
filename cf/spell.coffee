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
    @storage = new LocalStorage()
    today = new Date()
    comparison = today - Date.parse(@storage.created_at)
    days_ago = moment.duration(comparison).days()
    $("#age").append("<b>Your account is about " + days_ago  + " days old.</b>")
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
    words = entry.name.split(" ")
    size = 0
    for word in words
      size += word.length
    if words.length > 1
      last = "words"
    else
      last = "word"
    $("#revealed").empty().append(@reveal)
    $("dd#hint_stat").empty().append("This entry is <b>" + size + " letters</b> long and <b>" + words.length + " " + last + "</b> long.")
    $("dd#hint_define").empty().append(entry['definition'])
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
          $(".alert").empty().append("You had just spelled the word <b>" + @current + "</b> right!")
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
