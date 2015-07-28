(function() {
  this.LocalStorage = (function() {
    function LocalStorage() {
      if (localStorage.getItem("created_at") === null) {
        localStorage.setItem("created_at", new Date());
      }
      this.created_at = localStorage.getItem("created_at");
    }

    return LocalStorage;

  })();

}).call(this);
