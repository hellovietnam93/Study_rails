$(document).on("page:change", function() {
  $("#assignment_start_time, #assignment_end_time").datetimepicker();

  var $container = $("#assignments .assignments-list").isotope({
    itemSelector: ".element-item",
    layoutMode: "fitRows",
    getSortData: {
      start_date: function (elem) {
        return Date.parse($(elem).attr("data-start"));
      },
      type: "[data-type]",
      end_date: function (elem) {
        return Date.parse($(elem).attr("data-end"));
      },
      name: ".name"
    }
  });

  $("#sorts").on("click", "button", function() {
    var sortByValue = $(this).attr("data-sort-by");
    $container.isotope({
      sortBy: sortByValue
    });
  });
});
