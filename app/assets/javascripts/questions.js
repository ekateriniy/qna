$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');
    $('form#edit-question').removeClass('hide');
  });

  $('.question').on('submit', function(e){
    e.preventDefault();
    $('form#edit-question').addClass('hide');
    $('.edit-question-link').show();
  })
});
