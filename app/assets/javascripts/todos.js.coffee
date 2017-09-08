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
                        '<span class="glyphicon glyphicon-ok-sign"></span>' + listTitle + '<span class="pull-right">' +
                          '<span class="glyphicon glyphicon-step-backward" style="margin-right:0.5em; display:inline-block"></span>' +
                        '</span>' +
                      '</a>' +
                    '</div>'
    $.ajax({
      url: path + '/completed'
      method: 'PUT'
      complete: ->
        $(list).removeClass('list-group-item-danger')
        $(list).addClass('list-group-item-success')
        $(list).children().first().removeClass('glyphicon-question-sign')
        $(list).children().first().addClass('glyphicon-ok-sign')
        $('.recently-completed > div').last().remove()
        $('.recently-completed').prepend(completedList)
    })

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
      when "09" then "Sept"
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
