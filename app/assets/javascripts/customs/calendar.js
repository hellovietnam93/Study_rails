$(document).on("page:change", function() {
  $("#timetable_start_time, #timetable_end_time").datetimepicker();

  $(".select-timetable-details").select2({
    theme: "bootstrap",
    width: "100%",
    dropdownAutoWidth : true,
    placeholder: I18n.t("timetables.actions.add_syllabus")
  });

  $('#calendar').fullCalendar({
    contentHeight: 600,
    header: {
      left: "prev,next today",
      center: "title",
      right: "month, agendaWeek, agendaDay"
    },
    buttonText: {
      today: I18n.t("timetables.title.today"),
      month: I18n.t("timetables.title.month"),
      week: I18n.t("timetables.title.week"),
      day: I18n.t("timetables.title.day")
    },
    dayClick: function(date, jsEvent, view) {
      if ($("#calendar").attr("data-editable") == "true") {
        $("#new-timetable-modal").modal("show");
        $(".select-timetable-details").select2("val", "");
        date_click = date.format("YYYY/MM/DD HH:mm");
        $("#timetable_start_time").val(date_click);
        $("#timetable_end_time").val(date_click);
        $(".select2-search__field").css("width", "100%");
      }
    },
    eventMouseover: function( event, jsEvent, view ) {
      console.log(event.content);
    },
    eventClick: function(calEvent, jsEvent, view) {
      console.log(calEvent);
    },
    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
      return updateEvent(event);
    },
    eventRender: function(event, element) {
      var content = element.find(".fc-content");
      var time = $(content).find(".fc-time");
      var title = $(content).find(".fc-title");
      if (event.start._i < moment().format() && event.end && event.end._i > moment().format()) {
        $(time).addClass("text text-success");
      } else if (event.start._i < moment().format()) {
        $(time).addClass("text text-info");
        event.editable = false;
      } else if (event.start._i > moment().format()) {
        $(time).addClass("text text-danger");
      }
      $(time).append("<div class='divider'></div>");
    },
    displayEventEnd: true,
    selectable: true,
    editable: $("#calendar").attr("data-editable") == "false" ? false : true,
    eventLimit: true,
    events: BASE_URL + "class_rooms/" + $("#calendar").attr("data-class-room-id") + "/timetables.json",
    eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
      return updateEvent(event);
    }
  });
});

updateEvent = function(the_event) {
  $.ajax({
    type: "PUT",
    url: BASE_URL + "class_rooms/" + $("#calendar").attr("data-class-room-id") + "/timetables/" + the_event.id,
    data: { timetable: {
      title: the_event.title,
      start_time: "" + new Date(the_event.start).toUTCString(),
      end_time: "" + new Date(the_event.end).toUTCString(),
      content: the_event.content || "",
      sender_id: the_event.senderId,
      recipient_id: the_event.recipientId,
      all_day: the_event.allDay }
    },
    success: function() {
      $("#calendar").fullCalendar("refetchEvents");
    }
  });
};
