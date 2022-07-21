//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require activestorage
//= require action_cable
//= require cocoon
//= require_tree .

(function() {
  this.App || (this.App = {});
  App.cable = ActionCable.createConsumer();
}).call(this);
