$(document).ready(function() {
  $(document).on("page:change", function () {
    $("#courses #new-course").hide();
  });

  $(document).on("click", "#courses .btn-new-course", function (event) {
    $(".btn-new-course").hide();
    $("#new-course").show();
    $("form#new_course").show();
    $(".edit_course").remove();
  });

  $(document).on("click", "#courses .btn-cancel", function (event) {
    $("#error_explanation").remove();

    var form_parent = $(".btn-cancel").parent();
    if(form_parent.hasClass("new_course")){
      $(".btn-new-course").show();
      $("form#new_course")[0].reset();
      $("#new-course").hide();
    } else {
      $("form.edit_course")[0].reset();
      $(".edit_course").remove();
      $(".btn-new-course").show();
      $("#new-course").hide();
    }
  });
});
