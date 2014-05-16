$(->
  $(document).on('ajax:complete', ->
    Turbolinks.visit(document.URL)
  )
  setInterval((->
    Turbolinks.visit(document.URL)
  ), 10000)
)
