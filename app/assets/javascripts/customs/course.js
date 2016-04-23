$(document).ready(function() {
  $(document).on("hide.bs.modal", "#edit-course-modal", function (event) {
    $("#error_explanation").remove()
  });

  var $container = $("#courses .courses-list").isotope({
    itemSelector: ".element-item",
    layoutMode: "fitRows",
    getSortData: {
      uid: ".uid",
      name: ".name"
    }
  });
});
