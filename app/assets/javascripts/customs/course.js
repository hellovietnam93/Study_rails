$(document).ready(function() {
  $(document).on("hide.bs.modal", "#edit-course-modal", function (event) {
    $("#error_explanation").remove()
  });
});
