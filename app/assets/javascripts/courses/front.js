$(document).ready(function() {
  $('.valid-td').on('click', '*:not(:first-child)', function() {
    if ($(this).hasClass('success')) {
      $(this).removeClass('success');
      $(this).attr('value', null);
      $(this).trigger('update-hidden-form-value');
    }
    else if (!$(this).hasClass('danger')) {
      $(this).addClass('success');
      $(this).attr('value', $(this).parent().attr('value'));
      $(this).trigger('update-hidden-form-value');
    }
  });

  $('.monday, .tuesday, .wednesday, .thursday, .friday').bind('update-hidden-form-value', function(e) {
    // do more stuff now that #mydiv has been manipulated
    var target_id = $(this).attr("class").split(" ")[0];
    var column_index = $(this).parent().children().index($(this));

    //alert(target_id);
    //alert(typeof(column_index));
    switch(column_index) {
      case 1:
        free_time_cells = $('.monday.success');
        break;
      case 2:
        free_time_cells = $('.tuesday.success');
        break;
      case 3:
        free_time_cells = $('.wednesday.success');
        break;
      case 4:
        free_time_cells = $('.thursday.success');
        break;
      case 5:
        free_time_cells = $('.friday.success');
        break;
    }

    var free_time = free_time_cells.map(function() {
      return $(this).attr('value');
    }).get().join('');
    $("#" + target_id).val(free_time);
    return;
  });

/*
  $('.monday, .tuesday, .wednesday, .thursday, .friday').delay(100).on('click', function() {
    var target_id = $(this).attr("class").split(" ")[0];
    var column_index = $(this).parent().children().index($(this));

    //alert(typeof(column_index));
    switch(column_index) {
      case 1:
        var free_time = $('.monday.success');
        var values = free_time.map(function() {
          return $(this).attr('value');
        }).get().join('');
        $("#" + target_id).val(values);
        break;
    }

    //var row_index = $(this).parent().parent().children().index($(this).parent());

    //if (row_index >= 0 && row_index <= 3) {
      //row_index += 1;
    //}
    //else if (row_index == 4) {
      //row_index = "N";
    //}

    //var values = $('.' + $(this).attr('class')).map(function() {
      //return $(this).attr('value');
    //}).get().join('');

  })
*/
});

