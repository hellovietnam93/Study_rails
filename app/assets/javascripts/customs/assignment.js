$(document).ready(function() {
  $(document).on("click", "#new-assignment-modal .btn-cancel", function (event) {
    $("#error_explanation").remove();
    $("form.new_assignment")[0].reset();
    $("iframe").contents().find("body").empty();
  });

  $(document).on("click", "#edit-assignment-modal .btn-cancel", function (event) {
    $("#error_explanation").remove();
    $("form.edit_assignment")[0].reset();
    $("iframe").contents().find("body").empty();
  });

  $(document).on("click", ".assignment-show", function (event) {
    if ($(this).data("assignment-id") != undefined) {
      var assignmentId = $(this).data("assignment-id");
      var assignmentName = $(this).data("assignment-name");
      var assignmentContent = $(this).data("assignment-content");
      var assignmentStartDate = $(this).data("assignment-start-date");
      var assignmentEndDate = $(this).data("assignment-end-date");
      var assignmentType = $(this).data("assignment-type");
      var classroomID = $(this).data("assignment-class");

      var modal = $("#show-assignment-modal");

      modal.find(".modal-header").html(assignmentName);
      modal.find(".assignment-type").html(assignmentType);
      modal.find(".assignment-start-date").html(assignmentStartDate);
      modal.find(".assignment-end-date").html(assignmentEndDate);
      modal.find(".assignment-content").html(assignmentContent);
      modal.find(".assignment-edit").attr("data-assignment-id", assignmentId);
      modal.find(".assignment-edit").attr("data-assignment-class", classroomID);
      modal.find(".assignment-delete").attr("data-assignment-id", assignmentId);
      modal.find(".assignment-delete").attr("data-assignment-class", classroomID);
    }
  });

  $(document).on("click", ".assignment-edit", function (event) {
    $("#show-assignment-modal").closeModal();
    var assignmentId = $(this).data("assignment-id");
    var classroomID = $(this).data("assignment-class");
    var link = classroomID + "/assignments/" + assignmentId + "/edit";
    $.ajax({
      type: "GET",
      url: link
    });
  });

  $(document).on("click", ".assignment-delete", function (event) {
    var check = confirm('Are you sure?');
    if (check == true) {
      $("#show-assignment-modal").closeModal();
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

