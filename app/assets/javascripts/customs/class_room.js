$(document).on("page:change", function (){
  $.each($("[id^='class_room_questions_attributes_']"), function (key, value){
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
      type: "[data-type]",
      status: "[data-status]",
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

  $("#class_room_start_date, #class_room_end_date, #class_room_date_start, #class_room_date_end, #class_room_day_start, #user_birthday").datepicker({
    dateFormat: I18n.t("date.formats.js")
  });

  $("#class_room_time_start, #class_room_time_end").timepicker();

  // if ($("#class_room_repeat").is(":checked")) {
  //   $(".timetable-repeats").show();
  // } else {
  //   $(".timetable-repeats").hide();
  // }

  $("#class_room_repeat").change(function() {
    if(this.checked) {
      $("#class_room_full_day").prop("checked", false);
      $(".timetable-repeats").show();
    } else {
      $(".timetable-repeats").hide();
    }
  });

  $("#class_room_full_day").change(function() {
    if(this.checked) {
      $("#class_room_repeat").prop("checked", false);
      $(".timetable-repeats").hide();
    } else {
      // $(".timetable-repeats").hide();
      // todo
    }
  });

  $(document).on("change", "#class_room_repeat_type", function() {
    if($(this).val() == "every_week") {
      $(".repeat-on").show();
    } else {
      $(".repeat-on").hide();
    }
  });
});
