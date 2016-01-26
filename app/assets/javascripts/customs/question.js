$(document).on("click", ".answer-checkbox", function (){
  if ($(this).parents(".form-group").find("input[type=number]").val() == "")
    $(this).prop("checked", false);
  else
    $("input:checkbox").not(this).prop("checked", false);
});

$(document).on("click", ".question-type", function (event){
  if ($(this).val() == "single") {
    console.log("1")
  } else if ($(this).val() == "multiple") {
    console.log("2");
  } else {
    console.log("3");
  }
});
