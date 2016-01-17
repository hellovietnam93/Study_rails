$(document).ready(function() {
  $(document).on("page:change", function () {
    $("#semesters #new-semester").hide();
  });

  $(document).on("click", "#semesters .btn-new-semester", function (event) {
    $(".btn-new-semester").hide();
    $("#new-semester").show();
    $("form#new_semester").show();
    $(".edit_semester").remove();
  });

  $(document).on("click", "#semesters .btn-cancel", function (event) {
    $("#error_explanation").remove();

    var form_parent = $(".btn-cancel").parent();
    if(form_parent.hasClass("new_semester")){
      $(".btn-new-semester").show();
      $("form#new_semester")[0].reset();
      $("#new-semester").hide();
    } else {
      $("form.edit_semester")[0].reset();
      $(".edit_semester").remove();
      $(".btn-new-semester").show();
      $("#new-semester").hide();
    }
  });
});
