$(document).on "page:change", ->
  $(".button-remove").click (e) ->
    e.preventDefault()
    $(this).closest("div.answer-form").remove()

add_fields = (link, association, content) ->
  new_id = (new Date).getTime()
  regexp = new RegExp("new_" + association, "g")
  $("#answer_list").append content.replace(regexp, new_id)
  return

$(document).on "page:change", ->
  $("#user_avatar").bind "change", ->
    size_in_megabytes = @files[0].size / 1048576
    if size_in_megabytes > 5
      alert "Maximum file size is 5MB. Please choose a smaller file."
    return
  return

$(document).on "page:change", ->
  $("#add-answer-link").click ->
    association = $("#add-answer-link").data("association")
    content = $("#add-answer-link").data("content")
    content = content.replace(/(\\\")/g, "\"")
    content = content.replace(/(\\n)/g, "")
    content = content.replace(/(\\\/)/g, "/")
    add_fields null, association, content
    $(".button-remove").click (e) ->
      e.preventDefault()
      $(this).closest("div.answer-form").remove()
      return
    return
  return

total_times = undefined
time_over_msg = undefined

time_remaining = (total_times) ->
  if total_times <= 0
    $("#time-remaining").text time_over_msg
    if total_times == 0
      $("form").submit()
    $("[type=\"submit\"]").remove()
  else
    minutes = Math.floor(total_times / 60)
    seconds = total_times % 60
    $("#time-remaining").text minutes + " : " + seconds
    setTimeout (->
      time_remaining total_times - 1
      return
    ), 1000
  return

$(document).on "page:change", ->
  total_times = $("#hidden-data").data("time-remaining")
  time_over_msg = $("#hidden-data").data("time-over-msg")
  if total_times != undefined
    time_remaining total_times
  return
