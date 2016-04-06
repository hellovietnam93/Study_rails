$(document).on("page:change", function (){
  $.each($('[id^="class_room_questions_attributes_"]'), function (key, value){
    if ($(value).hasClass("question-name")){
      if ($(value)[0].value != "") {
        $(value).parent().parent().hide();
      }
    }
  });

  var $container = $("#class_rooms .classes-list").isotope({
    itemSelector: ".element-item",
    layoutMode: "fitRows",
    getSortData: {
      uid: ".uid",
      type: ".type",
      status: ".status",
      name: ".name"
    }
  });

  $("#sorts").on("click", "button", function() {
    var sortByValue = $(this).attr("data-sort-by");
    $container.isotope({
      sortBy: sortByValue
    });
  });

  $(".button-group").each(function (i, buttonGroup) {
    var $buttonGroup = $(buttonGroup);
    $buttonGroup.on("click", "button", function() {
      $buttonGroup.find(".is-checked").removeClass("is-checked");
      $(this).addClass("is-checked");
    });
  });
});
