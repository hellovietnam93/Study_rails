$(document).on("page:change", function() {
  var $container = $("#courses .courses-list").isotope({
    itemSelector: ".element-item",
    layoutMode: "fitRows",
    getSortData: {
      uid: ".uid",
      name: ".name"
    }
  });
});
