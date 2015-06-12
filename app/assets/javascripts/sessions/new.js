$(document).ready(function() {
  $('select#department').on("change", function() {
    var department = $(this).find(":selected").text();

    if (department === "機械系" || department === "化工系" ||
        department === "電機系") {
      $('.three-classes-options').show();
      $('.two-classes-options').css("display", "none");
    } else if (department === "材料系" || department === "土木系" ||
               department === "資訊系" || department === "建築系") {
      $('.two-classes-options').show();
      $('.three-classes-options').css("display", "none");
    } else {
      $('.three-classes-options').css("display", "none");
      $('.two-classes-options').css("display", "none");
    }
  });
});
