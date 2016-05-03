$(document).on("page:change", function() {
  var $container = $("#courses .courses-list").isotope({
    itemSelector: ".element-item",
    layoutMode: "fitRows",
    getSortData: {
      uid: ".uid",
      name: ".name"
    }
  });

  $("#sorts").on("click", "button", function() {
    var sortByValue = $(this).attr("data-sort-by");
    $container.isotope({
      sortBy: sortByValue
    });
  });

  $("form").on("click", ".remove_fields", function(event) {
    $(this).prev("input[type=hidden").val("1");
    $(this).closest(".row").hide();
    event.preventDefault();
  });

  $("form").on("click", ".add_fields", function(event) {
    time = new Date().getTime();
    regexp = new RegExp($(this).data("id"), "g");
    $(this).before($(this).data("fields").replace(regexp, time));
    event.preventDefault();
  });
});
