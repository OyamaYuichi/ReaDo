$(function() {
  $('.tab td').on('click', function(){
    $('.tab td').removeClass('select');
    $(this).addClass('select');
    $('.content .summary').addClass('hide');
    let index = $('.tab td').index($(this));
    $('.content .summary').eq(index).removeClass('hide');
  });
});