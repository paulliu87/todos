# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("span .glyphicon-edit").click (e) ->
    e.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId')
    path = $(list).attr('href')
    window.location = path + "/edit"


  $("span .glyphicon-trash").click (e) ->
    e.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId')
    path = $(list).attr('href')

    $.ajax({
      url: path
      method: 'DELETE'
    }).done ->
      $(list).parents('div').remove()
