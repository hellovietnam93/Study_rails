$(document).on("page:change", function() {
  $("#assignment_start_time, #assignment_end_time").datetimepicker();

  var $container = $("#assignments .assignments-list").isotope({
    itemSelector: ".element-item",
    layoutMode: "fitRows",
    getSortData: {
      start_time: ".start_time",
      type: ".type",
      end_time: ".end_time",
      name: ".name"
    }
  });
});
