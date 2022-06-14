module ApplicationHelper
  def owner?(object)
    current_user == object.author 
  end
end
