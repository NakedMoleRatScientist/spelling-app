// Generated by CoffeeScript 1.9.3
(function() {
  $(function() {
    var random_question, startUp, update_question, words;
    this.current = 0;
    $("#question, #answer").hide();
    words = $.getJSON("spellings.json");
    $.when(words).done((function(d) {
      return startUp(d);
    }));
    $.when(words).fail(function(data, status, error) {
      console.log(status + error);
    });
    startUp = function(data) {
      $("#question, #answer").show();
      return update_question(data);
    };
    random_question = function(data) {
      var choice;
      choice = Math.floor(Math.random() * data['words'].length);
      this.current = choice;
      return data['words'][choice];
    };
    update_question = function(data) {
      var word;
      word = random_question(data);
      return $("p#hint").empty().append(word['hint']);
    };
    return $("#answer").keypress(function(e) {
      if (e.which === 13) {
        return alert("Enter is pressed.");
      }
    });
  });

}).call(this);
