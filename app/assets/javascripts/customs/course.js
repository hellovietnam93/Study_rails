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
    if ($(this).data("association") == "syllabus_details") {
      temp = $(this).data("fields").replace("[" + $(this).data("id") + "]", "[" + time + "]");

      $(this).before(temp.replace("_" + $(this).data("id") + "_", "_" + time + "_"));
    } else {
      regexp = new RegExp($(this).data("id"), "g");
      $(this).before($(this).data("fields").replace(regexp, time));
    }
    event.preventDefault();
  });

  // $("[id*='syllabus_details_attributes']")

  // $.each($("[id*='syllabus_details_attributes']"), function (key, value){
  //   if ($(value).val() == ""){
  //     $(value).closest(".row").remove();
  //   }
  // });
});
