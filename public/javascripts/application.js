// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function () {
  $('input[type!="hidden"]').first().focus();
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

// BUTTONS
$('.fg-button').hover(
  function(){ $(this).removeClass('ui-state-default').addClass('ui-state-focus'); },
  function(){ $(this).removeClass('ui-state-focus').addClass('ui-state-default'); }
);

// MENUS      
$('#flat').menu({ 
  content: $('#flat').next().html(), // grab content from this page
  showSpeed: 400 
});
