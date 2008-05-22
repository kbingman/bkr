module ReorderPageControllerExtensions
  def reorder
    if request.post?
      sort_order = params[:sort_order].to_s.split(',').map { |i| Integer(i) rescue nil }.compact
      sort_order.each_with_index do |id, index|
        Page.update(id, :position => index)
      end
      redirect_to page_index_url
    else
      @page = Page.find(params[:id])
      @children = @page.children
    end
  end
end