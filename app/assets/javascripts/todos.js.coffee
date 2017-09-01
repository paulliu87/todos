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
      complete: ->
        $(list).parents('div .row').remove()
    })

  $("span .glyphicon-ok").click (e) ->
    e.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId')
    path = $(list).attr('href')
    debugger
    $.ajax({
      url: path + '/completed'
      method: 'PUT'
      complete: ->
        $(list).removeClass('list-group-item-danger')
        $(list).addClass('list-group-item-success')
        $(list).children().first().removeClass('glyphicon-question-sign')
        $(list).children().first().addClass('glyphicon-ok-sign')
    })
