# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# change the format of the month from interger to abbreviation
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  oldFormatLocation = ".cal-section p"
  replaceCal(oldFormatLocation)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# gliphicon actions (edit, destroy, completed and uncompleted)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  $(".list-group").on "click", "span .glyphicon-edit", (event) ->
    event.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId')
    path = $(list).attr('href')
    window.location = path + "/edit"

  $(".list-group").on "click", "span .glyphicon-trash", (event) ->
    event.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId')
    path = $(list).attr('href')
    $.ajax
      url: path
      method: 'DELETE'
      complete: ->
        $(list).parents('div .row').first().remove()

  $(".list-group").on "click", "span .glyphicon-ok", (event) ->
    event.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId').toString()
    listTitle = list.text().trim()
    path = $(list).attr('href')
    userID = window.location.pathname.match(/^\/users\/(\d+)/)[1]
    completedList = '<div class="row">' +
                      '<a href="/users/' + userID + '/todos/' + listID + '" data-list-id="' + listID + '" class="list-group-item list-group-item-action clearfix list-group-item-success">' +
                        '<span class="glyphicon glyphicon-ok-sign"></span>' + listTitle + '<span class="pull-right">' +
                          '<span class="glyphicon glyphicon-step-backward"></span>' +
                        '</span>' +
                      '</a>' +
                    '</div>'
    that = this
    $.ajax
      url: path + '/completed'
      method: 'PUT'
      dataType: "json"
      success: (data) ->
        $(that).closest(".row").remove()
        $('.recently-completed > div').last().remove()
        $('.recently-completed').prepend(completedList)

  $(".recently-completed").on "click", "span .glyphicon-step-backward", (event) ->
    event.preventDefault()
    list = $(this).closest('a')
    path = $(list).attr('href')
    userID = window.location.pathname.match(/^\/users\/(\d+)/)[1]
    prependLocation = $(".recently-completed")
    $.ajax
      url: path + '/uncompleted'
      method: 'PUT'
      dataType: "json"
      success: (data) ->
        uncompletedList = '<div class="row uncompleted-todos">' +
                            '<a href="/users/' + data["todo"].user_id + '/todos/' + data["todo"].id + '" data-list-id="' + data["todo"].id + '">' +
                              data["todo"].title +
                              '<span class="pull-right">' +
                                '<span class="glyphicon glyphicon-edit"></span>' +
                                '<span class="glyphicon glyphicon-trash"></span>' +
                                '<span class="glyphicon glyphicon-ok"></span></span><br><span>' +
                                data["todo"].deadline + '</span></a></div>'
        date = data["todo"].deadline.substring(0,10)
        uncompletedTodos = $("time[data-calendar-id=" + date + "]").parents(".calendar-header")
        classAttr = $(uncompletedTodos).next().children('a').attr("class")
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# remove todo from the completed list and append the new recently
# completed todos to completed list
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        removeTodos(prependLocation)
        for prependedList in data["completed_todos"]
          addList prependedList, prependLocation, userID

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# add a todo back to uncompleted list and apply css
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        $(uncompletedTodos).after(uncompletedList)
        $(uncompletedTodos).next().children('a').addClass(classAttr)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# fadein and fadeout feature while scrolling
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
$(window).on "load", ->
  $(window).scroll ->
    botBoundry = $(this).scrollTop() + $(this).innerHeight()
    topBoundry = $(this).scrollTop() + $('div.container-fluid').outerHeight()
    $(".row").each ->
      objectBottom = $(this).offset().top + $(this).outerHeight()
      objectTop = $(this).offset().top
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# bottom todo fadein and fadeout
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      if objectBottom < botBoundry and objectTop > topBoundry
        $(this).fadeTo(200,1) if ($(this).css("opacity")=="0")
      else if objectBottom > botBoundry and objectTop > topBoundry
        $(this).fadeTo(200,0) if ($(this).css("opacity")=="1")
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# top todo fadein and fadeout
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      else if objectBottom < botBoundry and objectTop < topBoundry
        $(this).fadeTo(10,0) if ($(this).css("opacity")=="1")
      else if objectBottom < botBoundry and objectTop > topBoundry
        $(this).fadeTo(10,1) if ($(this).css("opacity")=="0")
.scroll()

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# private functions
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
addList = (prependedList, prependLocation, userID) ->
  $(prependLocation).append(formateCompletedTodo(prependedList, userID))
removeTodos = (location) ->
  $(location).children('.row').remove()
formateCompletedTodo = (todo, userID) ->
  '<div class="row">' +
    '<a href="/users/' + userID + '/todos/' + todo.id + '" data-list-id="' + todo.id + '" class="list-group-item list-group-item-action clearfix list-group-item-success">' +
      '<span class="glyphicon glyphicon-ok-sign"></span>' + todo.title + '<span class="pull-right">' +
        '<span class="glyphicon glyphicon-step-backward"></span>' +
      '</span>' +
    '</a>' +
  '</div>'

calCal = (month) ->
  switch (month)
    when "01" then "Jan"
    when "02" then "Feb"
    when "03" then "Mar"
    when "04" then "Apr"
    when "05" then "May"
    when "06" then "Jun"
    when "07" then "Jul"
    when "08" then "Aug"
    when "09" then "Sep"
    when "10" then "Oct"
    when "11" then "Nov"
    when "12" then "Dec"

replaceCal = (oldFormatLocation) ->
  $(oldFormatLocation).each (index) ->
    num = $(this).text()
    month = ""
    month = calCal(num)
    $(this).text(month)
