$.rails.allowAction = (element) ->
  message = element.data("confirm")
  answer = false
  return true  unless message
  if $.rails.fire(element, "confirm")
    myCustomConfirmBox message, element
  false

myCustomConfirmBox = (message, element) ->
  $('.modal .btn-primary').unbind "click"
  $("#dialog-confirm .modal-body").html message
  $("#dialog-confirm").modal "show"
  $("#dialog-confirm .btn-grey-primary").click ->
    if element.attr("data-remote")
      $.rails.handleRemote element
    else
      $.rails.handleMethod element
    $("#dialog-confirm").modal "hide"
    $("#dialog-confirm .modal-body").html ""