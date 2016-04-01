$(document).on("page:change", function() {
  $("#assignment_start_date, #assignment_end_date").datepicker({
    dateFormat: "yy/mm/dd"
  });

  $(document).on("show.bs.modal", "#show-assignment-modal", function (event) {
    $("#error_explanation").remove();
    var $link = $(event.relatedTarget);

    var assignmentId = $link.data("assignment-id");
    var assignmentName = $link.data("assignment-name");
    var assignmentContent = $link.data("assignment-content");
    var assignmentStartDate = $link.data("assignment-start-date");
    var assignmentEndDate = $link.data("assignment-end-date");
    var assignmentType = $link.data("assignment-type");
    var classroomID = $link.data("assignment-class");

    $(this).find(".modal-title").html(assignmentName);
    $(this).find(".assignment-type").html(assignmentType);
    $(this).find(".assignment-start-date").html(assignmentStartDate);
    $(this).find(".assignment-end-date").html(assignmentEndDate);
    $(this).find(".assignment-content").html(assignmentContent);

    $(this).find(".assignment-edit").attr({
      "data-assignment-id": assignmentId,
      "data-assignment-class": classroomID,
      "data-assignment-name": assignmentName,
      "data-assignment-start-date": assignmentStartDate,
      "data-assignment-end-date": assignmentEndDate,
      "data-assignment-type": $link.data("type"),
      "data-assignment-content": assignmentContent
    });


    $(this).find(".assignment-delete").attr({
      "data-assignment-id": assignmentId,
      "data-assignment-class": classroomID
    });

    $(this).find(".assignment-submit").attr({
      "data-assignment-id": assignmentId,
      "data-assignment-class": classroomID
    });
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
      var assignmentStartDate = $link.attr("data-assignment-start-date");
      var assignmentEndDate = $link.attr("data-assignment-end-date");
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
      $(this).find(".modal-title").html("Edit " + assignmentName);
      $form.find("#assignment_name").val(assignmentName);
      $form.find("#assignment_assignment_type").val(assignmentType);
      $form.find("#assignment_start_date").val(assignmentStartDate);
      $form.find("#assignment_end_date").val(assignmentEndDate);
    }
  });

  $(document).on("shown.bs.modal", "#new-assignment-modal", function (event) {
    var $link = $(event.relatedTarget);

    var assignmentId = $link.data("assignment-id");
    console.log(assignmentId);
    CKEDITOR.instances.assignment_content.setData($(".assignment-edit-" + assignmentId).attr("data-assignment-content"));
  });

  $(document).on("click", ".assignment-delete", function (event) {
    var check = confirm("Are you sure?");
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
