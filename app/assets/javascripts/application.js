//= require jquery
//= require jquery_ujs
//= require foundation.min
//= require jquery-ui
//= require jquery_plugins/jquery.ui.datepicker-es
//= require jquery_plugins/jquery-ui-timepicker-addon
//= require jquery_plugins/jquery-ui-timepicker-es
//= require jquery_plugins/jquery.flexslider-min
//= require_self

$(document).ready(function () {
	$('input[type!="hidden"]').first().focus();
});

function remove_fields(link) {
	$(link).prev("input[type=hidden]").val("1");
	$(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g");
	$(link).parent().before(content.replace(regexp, new_id));
}
