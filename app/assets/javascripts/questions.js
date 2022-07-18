$(document).on('turbolinks:load', function(){
  const questionsList = $('.questions-list')

  $('.question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');
    $('form#edit-question').removeClass('hide');
    $('.delete-question-atached').removeClass('hide');
  });

  $('.question').on('submit', function(e){
    e.preventDefault();
    $('form#edit-question').addClass('hide');
    $('.edit-question-link').show();
  })

  $(function() {
     App.cable.subscriptions.create('QuestionsChannel', {
      connected: function() {
        this.perform('follow')
      },

      received: function(data) {
        questionsList.append(data)
      }
    })
  })
});
