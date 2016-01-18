$(document).ready(function() {
  $(document).on("page:change", function () {
    $("form.new_user_class").hide();
  });

  $(document).on("click", "#class_rooms .btn-login-class", function (event) {
    $(".btn-login-class").hide();
    $("form.new_user_class").show();
  });

  $(document).on("click", "#class_rooms .btn-cancel-login-class", function (event) {
    $("#error_explanation").remove();

    var form_parent = $(".btn-cancel").parent();
    $(".btn-login-class").show();
    $("form.new_user_class")[0].reset();
    $(".new_user_class").hide();
  });
});
