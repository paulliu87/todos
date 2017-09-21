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
    completedTodosLength = $('.recently-completed > div').length
    $.ajax
      url: path + '/completed'
      method: 'PUT'
      dataType: "json"
      success: (data) ->
        $(that).closest(".row").remove()
        if completedTodosLength >= 3
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
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        # remove todo from the completed list and append the new recently
        # completed todos to completed list
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        removeTodos(prependLocation)
        for prependedList in data["completed_todos"]
          addList prependedList, prependLocation

        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        # add a todo back to uncompleted list and apply css
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        uncompleteTodo(data["todo"])

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # scroll to specific date
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  $('.calendar .days').on "click", "li", (event) ->
    console.log($(this).text())
    date = findDate(this)
    if existedInDOM(date)
      calendarRow = $("time[data-calendar-id=" + date + "]")
      prevRow = $(calendarRow).parents('.row').prev().prev()
      $('html,body').animate {
        scrollTop: $(prevRow).offset().top
      }, 1000
    # else
      # display a messages and ask to create one todo

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
addList = (prependedList, prependLocation) ->
  $(prependLocation).append(formateCompletedTodo(prependedList))
removeTodos = (location) ->
  $(location).children('.row').remove()

formateCompletedTodo = (todo) ->
  '<div class="row">' +
    '<a href="/users/' + todo.user_id + '/todos/' + todo.id + '" data-list-id="' + todo.id + '" class="list-group-item list-group-item-action clearfix list-group-item-success">' +
      '<span class="glyphicon glyphicon-ok-sign"></span>' + todo.title + '<span class="pull-right">' +
        '<span class="glyphicon glyphicon-step-backward"></span>' +
      '</span>' +
    '</a>' +
  '</div>'

formateUncompletedTodo = (todo) ->
  '<div class="row uncompleted-todos">' +
  '<a href="/users/' + todo.user_id + '/todos/' + todo.id + '" data-list-id="' + todo.id + '">' +
  todo.title +
  '<span class="pull-right">' +
  '<span class="glyphicon glyphicon-edit"></span>' +
  '<span class="glyphicon glyphicon-trash"></span>' +
  '<span class="glyphicon glyphicon-ok"></span></span><br><span>' +
  todo.deadline + '</span></a></div>'

formatCalendarHeader = (todo) ->
  '<div class="row calendar-header">' +
      '<div class="cal-section col-md-1">' +
        '<time class="icon" data-calendar-id="' + todo.deadline.substring(0,10) + '">' +
          '<p>' + todo.deadline.substring(5,7) + '</p>' +
          '<div class="cal-top"></div>' +
          '<span>' + todo.deadline.substring(8,10) + '</span>' +
      '</time>' +
      '</div>' +
      '<img src="/images/summer.jpg"  class="pull-right col-md-10 img-reponsive img-rounded list-group-item list-group-item-action clearfix" />' +
  '</div>'

uncompleteTodo = (todo) ->
  position = findPosition(todo)
  insertTodo(todo, position)
  applyClass(todo, position)

findPosition = (todo) ->
  insertTodoDate = todo.deadline.substring(0,10)
  basePosition
  if existedInDOM(insertTodoDate)
    basePosition = $("time[data-calendar-id=" + insertTodoDate + "]").closest('.row').next()
  else
    $("time").each ->
      currentDate = $(this).attr("data-calendar-id")
      if currentDate > insertTodoDate
        basePosition = $(this).closest(".row")
        return false
  return basePosition

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

reverseCal = (month) ->
  switch (month)
    when "January" then "01"
    when "Febuary" then "02"
    when "March" then "03"
    when "April" then "04"
    when "May" then "05"
    when "June" then "06"
    when "July" then "07"
    when "August" then "08"
    when "September" then "09"
    when "OctoberR" then "10"
    when "November" then "11"
    when "December" then "12"

replaceCal = (oldFormatLocation) ->
  $(oldFormatLocation).each ->
    num = $(this).text()
    month = ""
    month = calCal(num)
    $(this).text(month)

existedInDOM = (date) ->
  $("time[data-calendar-id=" + date + "]").length == 1

insertTodo = (todo, position) ->
  calendarHeader = formatCalendarHeader(todo)
  uncompletedTodo = formateUncompletedTodo(todo)
  if existedInDOM(todo.deadline.substring(0,10))
    $(uncompletedTodo).insertBefore(position)
  else
    $(calendarHeader).insertBefore(position)
    $(uncompletedTodo).insertBefore(position)
  curMonthLocation = $("time[data-calendar-id=" + todo.deadline.substring(0,10) + "]").children('p')
  replaceCal(curMonthLocation)

applyClass = (todo, position) ->
  if isOverDue(todo)
    $(position).prev().children('a').addClass("pull-right col-md-10 list-group-item list-group-item-action clearfix list-group-item-danger")
  else
    $(position).prev().children('a').addClass("pull-right col-md-10 list-group-item list-group-item-action clearfix")

isOverDue = (todo) ->
  curTime = new Date()
  offset = new Date().getTimezoneOffset()
  todoDeadline = new Date(todo.deadline.substring(0,10))
  todoDeadline < curTime.addHours(offset / 60)

Date.prototype.addHours = (h) ->
  this.setTime(this.getTime() + (h*60*60*1000))
  this

findDate = (element) ->
  date = if $(element).text().trim().length == 2 then $(element).text().trim() else "0" + $(element).text().trim()
  temp = $(element).parents()[1]
  yearStart = $(temp).children('.month').text().trim().length
  defaultYear = $(temp).children('.month').text().trim().substring(yearStart - 4)
  monthStart = $(temp).children('.month').clone().children().children().last().text().trim().length
  defaultMonth = reverseCal($(temp).children('.month').clone().children().children().last().text().trim().substring(0,monthStart - 4).trim())
  searchParams = new URLSearchParams(document.location.search.substring(1))
  searchDate = searchParams.get("date").substring(0,8) + date
  YYMMDD = if window.location.search then searchDate else defaultYear + "-" + defaultMonth + "-" + date
