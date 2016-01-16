var import_data = function() {
  $(".file-select").bind("change", function() {
    var file_extension = this.files[0].name.split(".").pop().toLowerCase();
    var allowed_file, message;
    if($(this).attr("id") == "file-select-employee") {
      allowed_file = ["csv"];
      message = I18n.t("imports.allowed_csv")
    }
    else {
      allowed_file = ["csv", "json"];
      message = I18n.t("imports.allowed_csv_json")
    }

    var found_index = $.inArray(file_extension, allowed_file);
    if(found_index < 0) {
      alert(message);
      $(this).val("");
    }
  });
}

$(document).ready(function(){
  import_data();
  $("#form-submit-btn").click(function(){
    var file_inputs = $("input[type=file]");

    for (var i = 0; i < file_inputs.length; i++){
      if (file_inputs[i].value === "")
        file_inputs[i].disabled = true;
      else{
        var model = $("#" + file_inputs[i].id).data("model");

        $("#check-box-tag-file-select-" + model).prop("checked", true);
        $("#loading-image-" + model).removeClass("hidden");
      }
    }

    $("form").submit();
  });

  $(document).on("change", ".check-box", function(){
    $(".check-box").not(this).prop("checked", false);
  });
});

function validateForm() {
  var x = $("#link").get(0).value;
  if (x === null || x === "" || !(x.indexOf($(".link").data("validatelink")) > -1)) {
    alert(I18n.t("miss_link"));
    return false;
  }
  if ($("#selected_tags").find(":selected").val() === "None"){
    alert(I18n.t("miss_function_sync"));
    return false
  }
  if ($("#selected_tags").find(":selected").val() === "Evaluation"){
    if (!($("#select_period").find("input").is(":checked"))){
      alert(I18n.t("miss_period"));
      return false
    }
  }
}
