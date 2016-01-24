$(document).on("page:update", function() {
  $(".ckeditor").ckeditor();

  $(document).on("show.bs.modal", "#show-assignment-modal", function (event) {
    $("#error_explanation").remove();
    var $link = $(event.relatedTarget);
    if ($link.data("assignment-id") != undefined) {
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
      $(this).find(".assignment-edit").attr("data-assignment-id", assignmentId);
      $(this).find(".assignment-edit").attr("data-assignment-class", classroomID);
      $(this).find(".assignment-delete").attr("data-assignment-id", assignmentId);
      $(this).find(".assignment-delete").attr("data-assignment-class", classroomID);
    }
  });

  $(document).on("hide.bs.modal", "#new-assignment-modal", function (event) {
    $("iframe").contents().find("body").empty();
    $("form")[0].reset();
  });

  $(document).on("hide.bs.modal", "#edit-assignment-modal", function (event) {
    $("#edit-assignment-modal").remove();
    $(".modal-backdrop").remove();

  });

  $(document).on("click", ".assignment-edit", function (event) {
    var assignmentId = $(this).data("assignment-id");
    var classroomID = $(this).data("assignment-class");
    var link = classroomID + "/assignments/" + assignmentId + "/edit";
    $.ajax({
      type: "GET",
      url: link
    });
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
