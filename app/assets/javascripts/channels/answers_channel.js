$(function() {
  App.cable.subscriptions.create( "AnswersChannel", {
    connected: function() {
        this.perform('follow', { question_id: gon.question_id });
        console.log('followed!, question: ' + gon.question_id)
    },

    received: function(data) {
      console.log('received!')
      $('.answers').append(data)
    },
  })
});
