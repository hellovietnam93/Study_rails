$(document).on("page:change", function() {
  $("#assignment_start_time, #assignment_end_time").datetimepicker();

  $(document).on("show.bs.modal", "#show-assignment-modal", function (event) {
    $("#error_explanation").remove();
    var $link = $(event.relatedTarget);

    var assignmentId = $link.data("assignment-id");
    var assignmentName = $link.data("assignment-name");
    var assignmentContent = $link.data("assignment-content");
    var assignmentStartDate = $link.data("assignment-start-time");
    var assignmentEndDate = $link.data("assignment-end-time");
    var assignmentType = $link.data("assignment-type");
    var classroomID = $link.data("assignment-class");

    $(this).find(".modal-title").html(assignmentName);
    $(this).find(".assignment-type").html(assignmentType);
    $(this).find(".assignment-start-time").html(assignmentStartDate);
    $(this).find(".assignment-end-time").html(assignmentEndDate);
    $(this).find(".assignment-content").html(assignmentContent);

    $(this).find(".assignment-edit").attr({
      "data-assignment-id": assignmentId,
      "data-assignment-class": classroomID,
      "data-assignment-name": assignmentName,
      "data-assignment-start-time": assignmentStartDate,
      "data-assignment-end-time": assignmentEndDate,
      "data-assignment-type": $link.data("type"),
      "data-assignment-content": assignmentContent
    });


    $(this).find(".assignment-delete").attr({
      "data-assignment-id": assignmentId,
      "data-assignment-class": classroomID
    });

    if (moment().format(I18n.t("datepicker.time.js")) >= assignmentStartDate) {
      $(this).find(".assignment-submit").attr({
        "data-assignment-id": assignmentId,
        "data-assignment-class": classroomID
      });
    } else {
      $(this).find(".assignment-submit").hide();
    }
  });

  $(document).on("show.bs.modal", "#new-assignment-modal", function (event) {
    $("form.new_assignment")[0].reset();
    $("iframe").contents().find("body").empty();
    $("#error_explanation").remove();
    var $link = $(event.relatedTarget);

    if ($link.data("assignment-id") != undefined) {
      $("#show-assignment-modal").modal("hide");
      var assignmentId = $link.attr("data-assignment-id");
      var assignmentName = $link.attr("data-assignment-name");
      var assignmentStartDate = $link.attr("data-assignment-start-time");
      var assignmentEndDate = $link.attr("data-assignment-end-time");
      var assignmentType = $link.attr("data-assignment-type");
      var classroomID = $link.attr("data-assignment-class");
      var url = "/class_rooms/" + classroomID + "/assignments/" + assignmentId;

      $form = $(this).find("form");
      $form.attr("action", url);

      $("<input>").attr({
        type: "hidden",
        value: "patch",
        name: "_method"
      }).appendTo($form);
      $(this).find(".modal-title").html(I18n.t("form.buttons.edit") + assignmentName);
      $form.find("#assignment_name").val(assignmentName);
      $form.find("#assignment_assignment_type").val(assignmentType);
      $form.find("#assignment_start_time").val(assignmentStartDate);
      $form.find("#assignment_end_time").val(assignmentEndDate);
    }
  });

  $(document).on("shown.bs.modal", "#new-assignment-modal", function (event) {
    var $link = $(event.relatedTarget);

    var assignmentId = $link.data("assignment-id");
    CKEDITOR.instances.assignment_content.setData($(".assignment-edit-" + assignmentId).attr("data-assignment-content"));
  });

  $(document).on("click", ".assignment-delete", function (event) {
    var check = confirm(I18n.t("form.confirmation"));
    if (check == true) {
      var assignmentId = $(this).data("assignment-id");
      var classroomID = $(this).data("assignment-class");
      var link = classroomID + "/assignments/" + assignmentId;
      $.ajax({
        type: "DELETE",
        url: link
      });
    }
    else
      return false;
  });
});
