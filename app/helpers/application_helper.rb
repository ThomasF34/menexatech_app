module ApplicationHelper
  def full_title(title = '') 
    main_title = "MenexaTech"
    if title.empty?
      main_title
    else 
      title + " | " + main_title
    end
  end
end
