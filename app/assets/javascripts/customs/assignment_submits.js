$(document).on("ready", function() {
  $(document).on("show.bs.modal", "#submit-assignment-modal", function (event) {
    $("#error_explanation").remove();
    var $link = $(event.relatedTarget);
    var assignmentId = $link.attr("data-assignment-id");
    var classroomID = $link.attr("data-assignment-class");
    var assignment_submitId = $link.attr("data-assignment-submit-id");
    $("form.new_assignment_submit")[0].reset();
    $("iframe").contents().find("body").empty();

    $(this).find("#assignment_submit_assignment_id").val(assignmentId);

    if (assignment_submitId == undefined) {
      $("#show-assignment-modal").modal("hide");
    } else {
      var assignment_submitContent = $link.attr("data-assignment-submit-content");
      var url = "/class_rooms/" + classroomID + "/assignment_submits/" + assignment_submitId;

      $form = $(this).find("form");
      $form.attr("action", url);

      $("<input>").attr({
        type: "hidden",
        value: "patch",
        name: "_method"
      }).appendTo($form);

      CKEDITOR.instances.assignment_submit_content.setData(assignment_submitContent);
    }
  });
});
