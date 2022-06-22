module ApplicationHelper
  def flash_message(type)
    content_tag :p, flash[type].html_safe, class: "flash #{type}" if flash[type]
  end
end
