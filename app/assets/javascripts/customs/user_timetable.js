$(document).on("page:change", function() {
  $("#user-calendar").fullCalendar({
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
      console.log("ok");
    },
    eventMouseover: function( event, jsEvent, view ) {
      console.log(event.content);
    },
    eventClick: function(calEvent, jsEvent, view) {
      console.log(calEvent);
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
    eventLimit: true,
    events: BASE_URL + "users/" + $("#user-calendar").attr("data-user-id") + ".json"
    // eventColor: "#378006",
    // eventTextColor: "red"
  });
});
