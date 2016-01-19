$(document).ready(function() {
  $(document).on("page:change", function () {
    $("#assignments .new_assignment").hide();
  });

  $(document).on("click", "#assignments .btn-new-assignment", function (event) {
    var classId = $(this).data("class-room");
    $("form.new_assignment #assignment_class_room_id").val(classId);
    $(".btn-new-assignment").hide();
    $(".new_assignment").show();
    $("form.new_assignment").show();
    $(".edit_assignment").remove();
  });

  $(document).on("click", "#assignments .btn-cancel", function (event) {
    $("#error_explanation").remove();

    var form_parent = $(".btn-cancel").parent();
    if(form_parent.hasClass("new_assignment")){
      $(".btn-new-assignment").show();
      $("form.new_assignment")[0].reset();
      $(".new_assignment").hide();
    } else {
      $(".edit_assignment").remove();
      $(".btn-new-assignment").show();
    }
    $(".edit_assignment").remove();
    $("iframe").contents().find("body").empty();
  });
});
