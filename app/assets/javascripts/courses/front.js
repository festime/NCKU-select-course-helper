$(document).ready(function() {
  var numbers = [ '1', '2', '3', '4', 'N', '5', '6', '7', '8', '9' ];
  $.each(numbers, function(index, value) {
    $('#course-table tbody').children('tr').eq(index).children('td').eq(0).text(value);
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
