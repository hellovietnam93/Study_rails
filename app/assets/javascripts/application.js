// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require datetimepicker
//= require moment.min
//= require jquery-ui.custom.min
//= require fullcalendar.min
//= require turbolinks
//= require ckeditor/init
//= require ckeditor/reinit
//= require ckeditor/adapters/jquery
//= require bootstrap-sprockets
//= require jquery_nested_form
//= require isotope
//= require_tree ./customs

$(document).on("ready", function() {
  set_timetout();
});


function set_timetout() {
  $(".alert").delay(3000).slideUp();
}
