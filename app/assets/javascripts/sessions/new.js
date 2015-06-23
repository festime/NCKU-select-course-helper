$(document).ready(function() {
  $('select#institute_code').on("change", function() {
    var department = $(this).find(":selected").text();

    if (department === "機械系" || department === "化工系" ||
        department === "電機系") {
      $('.two-classes-options').children('label').remove();
      $('.three-classes-options').children('label').remove();
      $('#class_name').remove();
      $('.three-classes-options').append('<label for="class_name">班別</label><select name="class_name" id="class_name" class="form-control"><option value="甲">甲</option><option value="乙">乙</option><<option value="丙">丙</option>/select>');

    } else if (department === "材料系" || department === "土木系" ||
               department === "資訊系" || department === "建築系") {
      $('.two-classes-options').children('label').remove();
      $('.three-classes-options').children('label').remove();
      $('#class_name').remove();
      $('.two-classes-options').append('<label for="class_name">班別</label><select name="class_name" id="class_name" class="form-control"><option value="甲">甲</option><option value="乙">乙</option></select>');

    } else {
      $('.two-classes-options').children('label').remove();
      $('.three-classes-options').children('label').remove();
      $('#class_name').remove();
    }
  });
});
