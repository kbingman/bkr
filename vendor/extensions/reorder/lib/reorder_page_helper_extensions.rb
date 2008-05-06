module ReorderPageHelperExtensions
  def page_icon(page)
    icon = page.virtual? ? "virtual-page" : "page"
    image(icon, :class => "icon", :alt => 'page-icon', :title => '', :align => 'center')
  end
end