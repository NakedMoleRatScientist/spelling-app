class @LocalStorage
  constructor: () ->
    if localStorage.getItem("created_at") == null
      localStorage.setItem("created_at", new Date())
    @created_at = localStorage.getItem("created_at")
