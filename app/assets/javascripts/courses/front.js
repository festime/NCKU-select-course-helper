$(document).ready(function() {
  var i;

  if (typeof obligatory_courses === 'undefined') {
    obligatory_courses = [];
  }

  $('.select-this-day-free-time').on('click', function() {
    var day = $(this).attr('class').split(' ')[0];
    //$('td.'+day+'').not('.success').not('.danger').addClass('success');
    Array.prototype.forEach.call($('td.'+day+'').not('.success').not('.danger'), function(obj) {
      $(obj).addClass('success');
      $(obj).attr('value', $(obj).parent().attr('value'));
    });
    $(this).trigger('update-hidden-form-value');
  });

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
    else if (!$(this).hasClass('danger') && !$(this).hasClass('success') &&
      !$(this).hasClass('warning')) {
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
});

$(document).on('click', ".glyphicon-plus", function() {
  var course_name = $(this).closest('tr').children('td').eq(7).children().text();
  var course_schedule = $(this).closest('tr').children('td').eq(13).text();
  var parsed_schedule = {1: [], 2: [], 3: [], 4: [], 5: []};
  var zero_to_nine = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  // ex: [1]2~3, [2]2~4
  while (true) {
    var continuous_courses = course_schedule.match(/\[\d\]\d~\d/);

    if (continuous_courses) {
      var day = continuous_courses[0].match(/\[\d\]/)[0].match(/\d/)[0];
      var schedule_of_this_day = continuous_courses[0].match(/\d~\d/)[0];
      var schedule_start = parseInt(schedule_of_this_day.split('~')[0]);
      var schedule_end   = parseInt(schedule_of_this_day.split('~')[1]) + 1;
      parsed_schedule[day] = parsed_schedule[day].concat(zero_to_nine.slice(schedule_start, schedule_end));
      course_schedule = course_schedule.replace(/\[\d\]\d~\d/, '');
    }
    else {
      break;
    }
  }

  // ex: [2]N
  while (true) {
    var single_course = course_schedule.match(/\[\d\]\d|\[\d\]N/);

    if (single_course) {
      var day = single_course[0].match(/\[\d\]/)[0].match(/\d/)[0];
      var schedule_of_this_day = single_course[0].match(/\]\d/)[0];
      parsed_schedule[day] = parsed_schedule[day].concat(schedule_of_this_day);
      course_schedule = course_schedule.replace(/\[\d\]\d|\[\d\]N/, '');
    }
    else {
      break;
    }
  }

  var user_can_select_this_course = true;
  Object.keys(parsed_schedule).forEach(function(day) {
    for (var j = 0 ; j < parsed_schedule[day].length ; ++j) {
      var course_time_index = parsed_schedule[day][j];
      var target_cell = $('tr[value='+course_time_index+'] td:nth-child('+day+')').next();

      if (target_cell.text() != "") {
        user_can_select_this_course = false;
      }
    }
  });

  if (user_can_select_this_course) {
    Object.keys(parsed_schedule).forEach(function(day) {
      for (var j = 0 ; j < parsed_schedule[day].length ; ++j) {
        var course_time_index = parsed_schedule[day][j];
        var target_cell = $('tr[value='+course_time_index+'] td:nth-child('+day+')').next();
        target_cell.addClass('warning');
        target_cell.text(course_name);
      }
    });
    //$(this).parent().append('<i class="glyphicon glyphicon-remove"></i>');
    //$(this).remove();
  }
  else {
    alert("這個時段已經有課囉");
  }
});

$(document).on("click", ".glyphicon-remove", function() {
  var courseId = $(this).closest('tr').attr('id').split('-')[1];
  var courseInTable = $('.course-table-'+courseId+'');

  courseInTable.text('');
  courseInTable.removeClass('info');
  $(this).closest('tr').remove();
});

$(document).on('mouseenter', ".glyphicon-plus", function() {
  $(this).css('cursor', 'pointer');
});

$(document).on('mouseenter', ".glyphicon-remove", function() {
  $(this).css('cursor', 'pointer');
});

$(document).on('mouseenter', ".glyphicon-collapse-down", function() {
  $(this).css('cursor', 'pointer');
});

$(document).on('mouseenter', ".glyphicon-collapse-up", function() {
  $(this).css('cursor', 'pointer');
});

$(document).on('click', ".glyphicon-collapse-up", function() {
  $(this).parent().next().hide();
  $(this).parent().append('<i class="glyphicon glyphicon-collapse-down" style="cursor: pointer;"></i>');
  $(this).remove();
});

$(document).on('click', ".glyphicon-collapse-down", function() {
  $(this).parent().next().show();
  $(this).parent().append('<i class="glyphicon glyphicon-collapse-up" style="cursor: pointer;"></i>');
  $(this).remove();
});
