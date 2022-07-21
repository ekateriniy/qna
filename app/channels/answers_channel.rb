class AnswersChannel < ActionCable::Channel::Base
  def follow(data)
    stream_from "answers_question_#{data['question_id']}"
  end
end
