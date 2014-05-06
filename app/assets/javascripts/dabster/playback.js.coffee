$(->
  source = new EventSource('/playback_status')
  source.addEventListener('status-update', (e) ->
    console.log(e.data)
  )
)
