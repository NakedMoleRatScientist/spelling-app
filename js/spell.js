// Generated by CoffeeScript 1.9.3
(function() {
  $(function() {
    var emptyInput, random_question, startUp, update_keyHandler, update_question, words;
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
      this.current = "";
      this.fail = 0;
      update_question(data);
      return this.data = data;
    };
    random_question = function(data) {
      var choice;
      choice = Math.floor(Math.random() * data['words'].length);
      this.current = data['words'][choice]['name'];
      return data['words'][choice];
    };
    update_question = function(data) {
      var entry, size;
      entry = random_question(data);
      update_keyHandler();
      size = entry.name.length;
      $("dd#hint_stat").empty().append("This word is " + size + " long.");
      $("dd#hint_define").empty().append(entry['hint']);
      return $("dd#hint_sentence").empty().append(entry['example']);
    };
    emptyInput = function() {
      return $("input#input_answer").val("");
    };
    return update_keyHandler = function() {
      $("#input_answer").off();
      return $("#input_answer").keydown((function(_this) {
        return function(e) {
          var attempt, last;
          if (e.which === 13) {
            attempt = $("#input_answer").val();
            if (attempt.toLowerCase() === _this.current.toLowerCase()) {
              $(".alert").addClass("alert-success");
              $(".alert").empty().append("You had just spelt the word " + _this.current + " right!");
              update_question(_this.data);
              return emptyInput();
            } else {
              _this.fail += 1;
              $(".alert").addClass("alert-danger");
              if (_this.fail > 1) {
                last = " times.";
              } else {
                last = " time.";
              }
              $(".alert").empty().append("You have failed " + _this.fail + last);
              return emptyInput();
            }
          }
        };
      })(this));
    };
  });

}).call(this);
