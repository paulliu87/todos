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
        $(list).parents('div .row').first().remove()
    })

  $("span .glyphicon-ok").click (e) ->
    e.preventDefault()
    list = $(this).closest('a')
    listID = $(list).data('listId').toString()
    listTitle = list.text().trim()
    path = $(list).attr('href')
    userID = window.location.pathname.match(/^\/users\/(\d+)/)[1]
    completedList = '<div class="row" style="margin-top: 0.1em">' +
                      '<a href="/users/' + userID + '/todos/' + listID + '" recent-list-id="' + listID + '" class="list-group-item list-group-item-action clearfix list-group-item-success">' +
                        '<span class="glyphicon glyphicon-ok-sign" style="margin-right:0.5em; display:inline-block"></span>' + listTitle + '<span class="pull-right">' +
                          '<span class="glyphicon glyphicon-step-backward"></span>' +
                        '</span>' +
                      '</a>' +
                    '</div>'
    $.ajax(
      url: path + '/completed'
      method: 'PUT'
      dataType: "json"
      ).success((data) ->
        $(list).removeClass('list-group-item-danger')
        $(list).addClass('list-group-item-success')
        $('.recently-completed > div').last().remove()
        $('.recently-completed').prepend(completedList)
      )

  $("span .glyphicon-step-backward").click (e) ->
    e.preventDefault()
    list = $(this).closest('a')
    path = $(list).attr('href')
    # debugger
    $.ajax(
      url: path + '/uncompleted'
      method: 'PUT'
      dataType: "json"
    ).success((data) ->
      uncompletedList = '<div class="row uncompleted-todos" style="margin-top: 0.1em">' +
                          '<a href="/users/' + data.user_id + '/todos/' + data.id + '" data-list-id="' + data.id + '">' +
                            data.title +
                            '<span class="pull-right">' +
                              '<span class="glyphicon glyphicon-edit" style="margin-right:0.5em; display:inline-block"></span>' +
                              '<span class="glyphicon glyphicon-trash" style="margin-right:0.5em; display:inline-block"></span>' +
                              '<span class="glyphicon glyphicon-ok"></span>' +
                            '</span><br><span>' + data.deadline + '</span></a></div>'
      date = data.deadline.substring(0,10)
      uncompletedTodos = $("time[data-calendar-id=" + date + "]").parents(".calendar-header")
      classAttr = $(uncompletedTodos).next().children('a').attr("class")
      # debugger
      $(uncompletedTodos).after(uncompletedList)
      $(uncompletedTodos).next().children('a').addClass(classAttr)
    )

# # # # # # # # # # # # # # # # # # # # # # # #
# change the format of the month from interger to abbreviation
# # # # # # # # # # # # # # # # # # # # # # # #

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

  replaceCal = () ->
    $('.cal-section p').each (index) ->
      num = $(this).text()
      month = ""
      month = calCal(num)
      $(this).text(month)
  replaceCal()


$(window).on "load", ->
  $(window).scroll ->
    botBoundry = $(this).scrollTop() + $(this).innerHeight()
    topBoundry = $(this).scrollTop() + $('div.container-fluid').outerHeight()
    # console.log("topBoundry is " + topBoundry)
    # console.log($(".row:nth(0)").offset().top)
    $(".row").each ->
      objectBottom = $(this).offset().top + $(this).outerHeight()
      objectTop = $(this).offset().top
      # bottom todo fadein and fadeout
      if objectBottom < botBoundry and objectTop > topBoundry
        $(this).fadeTo(200,1) if ($(this).css("opacity")=="0")
      else if objectBottom > botBoundry and objectTop > topBoundry
        $(this).fadeTo(200,0) if ($(this).css("opacity")=="1")
      # top todo fadein and fadeout
      else if objectBottom < botBoundry and objectTop < topBoundry
        $(this).fadeTo(10,0) if ($(this).css("opacity")=="1")
      else if objectBottom < botBoundry and objectTop > topBoundry
        $(this).fadeTo(10,1) if ($(this).css("opacity")=="0")
.scroll()
