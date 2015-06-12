$(document).ready(function() {
  var i;

  if (typeof obligatory_courses === 'undefined') {
    obligatory_courses = [];
  }

  for (i = 0 ; i < obligatory_courses.length ; ++i) {
    // $('tr[value="5"]');
    var course_name = obligatory_courses[i]["course_name"];
    var schedule = obligatory_courses[i]["schedule"];
    Object.keys(schedule).forEach(function(day) {
      for (var j = 0 ; j < schedule[day].length ; ++j) {
        var course_time_index = schedule[day][j];
        var target_cell = $('tr[value='+course_time_index+'] td:nth-child('+day+')').next();
        target_cell.addClass('danger');
        target_cell.text($(course_name).html());
      }
    });
  }

  $('.valid-td').on('click', '*:not(:first-child)', function() {
    if ($(this).hasClass('success')) {
      $(this).removeClass('success');
      $(this).attr('value', null);
      $(this).trigger('update-hidden-form-value');
    }
    else if ($(this).hasClass('danger')) {
      $(this).removeClass('danger');
      $(this).text('');
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

    switch (column_index) {
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

