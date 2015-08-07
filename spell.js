(function() {
  $(function() {
    var emptyInput, randomLetter, random_question, spaced_display, startUp, update_keyHandler, update_question, words;
    $("#question, #answer").hide();
    $("#finished").hide();
    words = $.getJSON("spellings.json");
    $.when(words).done((function(d) {
      return startUp(d);
    }));
    spaced_display = function(target) {
      var i, len, letter, result, splitted;
      splitted = target.split("");
      result = "";
      for (i = 0, len = splitted.length; i < len; i++) {
        letter = splitted[i];
        result = result.concat(letter + " ");
      }
      return result;
    };
    $.when(words).fail(function(data, status, error) {
      console.log(status + error);
    });
    startUp = function(data) {
      var comparison, days_ago, i, ref, results, today;
      this.order = (function() {
        results = [];
        for (var i = 0, ref = data['words'].length - 1; 0 <= ref ? i <= ref : i >= ref; 0 <= ref ? i++ : i--){ results.push(i); }
        return results;
      }).apply(this);
      this.order = _.shuffle(this.order);
      $("#question, #answer").show();
      this.storage = new LocalStorage();
      today = new Date();
      comparison = today - Date.parse(this.storage.created_at);
      days_ago = moment.duration(comparison).days();
      $("#age").append("<b>Your account is about " + days_ago + " days old.</b>");
      $("#listing").append("Currently, we have " + data['words'].length + " words in the spelling dictionary.");
      this.current = "";
      this.fail = 0;
      this.reveal = "";
      this.unfinished = [];
      update_question(data);
      return this.data = data;
    };
    random_question = function(data) {
      var choice, i, j, ref, ref1, results, results1;
      choice = this.order.pop();
      if (this.order.length === 0) {
        $("#question, #answer").hide();
        $("#finished").show();
        return -1;
      }
      this.current = data['words'][choice]['name'];
      (function() {
        results = [];
        for (var i = 1, ref = this.current.length; 1 <= ref ? i <= ref : i >= ref; 1 <= ref ? i++ : i--){ results.push(i); }
        return results;
      }).apply(this).forEach(function() {
        return this.reveal = this.reveal.concat("_");
      });
      this.unfinished = (function() {
        results1 = [];
        for (var j = 0, ref1 = this.current.length - 1; 0 <= ref1 ? j <= ref1 : j >= ref1; 0 <= ref1 ? j++ : j--){ results1.push(j); }
        return results1;
      }).apply(this);
      return data['words'][choice];
    };
    update_question = function(data) {
      var entry, i, last, len, size, word;
      entry = random_question(data);
      if (entry === -1) {
        return -1;
      }
      update_keyHandler();
      words = entry.name.split(" ");
      size = 0;
      for (i = 0, len = words.length; i < len; i++) {
        word = words[i];
        size += word.length;
      }
      if (words.length > 1) {
        last = "words";
      } else {
        last = "word";
      }
      $("#revealed").empty().append(spaced_display(this.reveal));
      $("dd#hint_stat").empty().append("This entry is <b>" + size + " letters</b> long and <b>" + words.length + " " + last + "</b> long.");
      $("dd#hint_define").empty().append(entry['definition']);
      return $("dd#hint_sentence").empty().append(entry['example']);
    };
    emptyInput = function() {
      return $("input#input_answer").val("");
    };
    randomLetter = function() {
      var decide, n;
      if (this.reveal === this.current) {
        return;
      }
      decide = Math.floor(Math.random() * this.unfinished.length);
      n = this.unfinished[decide];
      this.reveal = this.reveal.substring(0, n) + this.current[n] + this.reveal.substring(n + 1);
      return this.unfinished.splice(decide, 1);
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
              $(".alert").empty().append("You had just spelled the word <b>" + _this.current + "</b> right!");
              $("#revealed").empty();
              _this.reveal = "";
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
              randomLetter();
              $("#revealed").empty().append(spaced_display(_this.reveal));
              $(".alert").empty().append("You have failed " + _this.fail + last);
              return emptyInput();
            }
          }
        };
      })(this));
    };
  });

}).call(this);
