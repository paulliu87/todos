# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
    $("#list-edit").click(function(e) {
      e.preventDefault();
      var $tar = e.target;
      var $list = $(this).closest('a');
      var $listID = $(list).data('listId');
      var path = $(list).attr('href');
      window.location = path + "/edit";
    }
});
