$(document).on("page:change", function() {
  $('#calendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month, agendaWeek, agendaDay'
    },
    dayClick: function(date, jsEvent, view) {
      console.log('Clicked on: ' + date.format());
      // console.log('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);

      // console.log('Current view: ' + view.name);
      // $(this).css('background-color', 'red');
    },
    eventMouseover: function( event, jsEvent, view ) {
      console.log(event.title);
    },
    eventClick: function(calEvent, jsEvent, view) {

        alert('Event: ' + calEvent.title);
        alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
        alert('View: ' + view.name);

        // change the border color just for fun
        $(this).css('border-color', 'red');

    },
    selectable: true,
    editable: true,
    eventLimit: true, // allow "more" link when too many events
    events: [
      {
        title: 'All Day Event',
        start: '2016-01-01'
      },
      {
        title: 'Long Event',
        start: '2016-01-07',
        end: '2016-01-10'
      },
      {
        id: 999,
        title: 'Repeating Event',
        start: '2016-01-09T16:00:00'
      },
      {
        id: 999,
        title: 'Repeating Event',
        start: '2016-03-16T16:00:00'
      },
      {
        title: 'Conference',
        start: '2016-03-11',
        end: '2016-03-13'
      },
      {
        title: 'Meeting',
        start: '2016-03-12T10:30:00',
        end: '2016-03-12T12:30:00'
      },
      {
        title: 'Lunch',
        start: '2016-03-12T12:00:00'
      },
      {
        title: 'Meeting',
        start: '2016-03-12T14:30:00'
      },
      {
        title: 'Happy Hour',
        start: '2016-03-12T17:30:00'
      },
      {
        title: 'Dinner',
        start: '2016-03-12T20:00:00'
      },
      {
        title: 'Birthday Party',
        start: '2016-03-13T07:00:00'
      },
      {
        title: 'Click for Google',
        url: 'http://google.com/',
        start: '2016-03-28'
      }
    ],
    eventResize: function(event, delta, revertFunc) {

        alert(event.title + " end is now " + event.end.format());

        if (!confirm("is this okay?")) {
            revertFunc();
        }

    }
  });
});
