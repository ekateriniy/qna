$(function() {
  App.cable.subscriptions.create( "CommentsChannel", {
    connected: function() {
        this.perform('follow', { question_id: gon.question_id });
    },

    received: function(data) {
      comments = `.${data.resource}-id-${data.id}-comments`
      $(`${comments} .comments-list`).append(data.message)
      $(`${comments} #comment_body`).val('')
    },
  })
});
