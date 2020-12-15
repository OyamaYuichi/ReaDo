$(function() {
  $('.tab td').on('click', function(){
    $('.tab td').removeClass('select');
    $(this).addClass('select');
    $('.book-show-content .book').addClass('hide');
    let index = $('.tab td').index($(this));
    $('.book-show-content .book').eq(index).removeClass('hide');
  });
});