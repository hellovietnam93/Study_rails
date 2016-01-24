$(document).ready(function() {
  $.each($('[id^="class_room_questions_attributes_"]'), function (key, value){
    if ($(value).hasClass("question-name")){
      if ($(value)[0].value != "") {
        $(value).parent().parent().hide();
      }
    }
  });
});
