// This is a manifest file that"ll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin"s vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It"s not advisable to add code directly here, but if you do, it"ll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require materialize-sprockets
//= require materialize/extras/nouislider
//= require turbolinks
//= require ckeditor/init
//= require_tree ./customs

$(document).on("ready", function() {
  set_timetout();
});


function set_timetout() {
  $(".alert").delay(3000).slideUp();
}

$(document).on("page:change", function () {
  $(".dropdown-button").dropdown({
    inDuration: 300,
    outDuration: 225,
    constrain_width: false,
    hover: true,
    gutter: 0,
    belowOrigin: false,
    alignment: "left"
  });

  $(".modal-trigger").leanModal({
      dismissible: false,
      opacity: .5,
      in_duration: 300,
      out_duration: 200
    }
  );
})

$(".datepicker").pickadate({
  selectMonths: true, // Creates a dropdown to control month
  selectYears: 15 // Creates a dropdown of 15 years to control year
});
