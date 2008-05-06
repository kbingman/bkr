module LegacyTags
  include Radiant::Taggable

  tag "hello" do |tag|
    "Hello #{ tag.attr['name'] || 'world' }!"
  end
  
  desc %{
    Gives all pages with the given tag
   
    *Usage:* 
    <pre><code><r:if_tagged [tag="tag_name"]>...</r:if_tagged></code></pre>
  }
  tag 'if_tagged' do |tag|
    page = tag.locals.page
    tag_part = tag.attr['tag']
    if page.part('tag')
      tags = page.part('tag').content.split(', ')
      if tags.include?(tag_part)
        tag.expand
      end
    end
  end
  
  
  desc %{
    Gives all tags for a given page
  }
  tag "tags" do |tag|
    page = tag.locals.page
    if page.part('tag')
      tags = page.part('tag').content.split(', ')
      tag.expand
    end
  end
  
  desc %{
    Cycles through a tag list for each page. Can be used for links and such.
   
    *Usage:* 
    <pre><code><r:tags:each>...</r:tags:each></code></pre>
  }
  tag 'tags:each' do |tag|
    page = tag.locals.page
    result = []
    if page.part('tag')
      tags = page.part('tag').content.split(', ')
      tags.each do |t|
        tag.locals.tags = t
        result << tag.expand
      end
    end
    result
  end
  
  desc %{
    Outputs the tag name. 
  }   
  tag 'tags:each:tag_name' do |tag|
    tag_name = tag.locals.tags
    tag_name
  end
  
  desc %{
    Outputs the sanitized tag name
   
    *Usage:* 
    <pre><code><r:tag_slug>...</r:tag_slug></code></pre>
  }   
  tag 'tags:each:tag_slug' do |tag|
    tag_name = tag.locals.tags
    tag_slug = tag_name.gsub(/[^\w._-]/, '-') 
    tag_slug
  end
  
  desc %{
    Renders the username of the Author of the current page. Can be used to build a link to that author's bio.
   
    *Usage:* 
    <pre><code><r:author_url /></code></pre>
  }
  tag 'author_url' do |tag|
    page = tag.locals.page
    if author = page.created_by
      author.login
    end
  end
  
  desc %{
    Conditional for author. Used for my hacked up version of tags and author bios.
   
    *Usage:* 
    <pre><code><r:if_author name=[author name]>...</r:if_author></code></pre>
  }
  tag 'if_author' do |tag|
    page = tag.locals.page
    author_name = tag.attr['name']
    if author = page.created_by
      page_author = author.login
    end
    if page_author == author_name
      tag.expand
    end
  end
  
  
  desc %{
    Renders the containing elements only if the page has children.
   
    *Usage:* 
    <pre><code><r:if_children>...</r:if_children></code></pre>
  }
  tag 'if_children' do |tag|
    page = tag.locals.page
    children = page.children
    unless children.empty?
      tag.expand
    end
  end
  
  desc %{
    Renders the containing elements only if the page doesn't have children.
   
    *Usage:* 
    <pre><code><r:unless_children>...</r:unless_children></code></pre>
  }
  tag 'unless_children' do |tag|
    page = tag.locals.page
    children = page.children
    if children.empty?
      tag.expand
    end
  end

  desc %{
    cycles through each sibling of a page, without showing the page itself
    # <r:siblings:each [by="attribute"] [order="asc|desc"] 
    # [status="draft|reviewed|published|hidden|all"]>...</r:siblings:each>
    # adding a boolean switch to decide if the current page is included would be nice and not too hard...
   
    *Usage:* 
    <pre><code><r:siblings:each [by="attribute"] [order="asc|desc"] [status="draft|reviewed|published|hidden|all"]>...</r:siblings:each></code></pre>
  }
  tag "siblings:each" do |tag|
    attr = tag.attr.symbolize_keys
    
    options = {}
    
    by = (attr[:by] || 'position').strip
    unless by.blank?
      order = (attr[:order] || 'asc').strip
      order_string = ''
      if @page.attributes.keys.include?(by)
        order_string << by
      else
        raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
      end
      if order =~ /^(asc|desc)$/i
        order_string << " #{$1.upcase}"
      else
        raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
      end
      options[:order] = order_string if order_string
    end
    
    [:limit, :offset].each do |symbol|
      if number = attr[symbol]
        if number =~ /^\d{1,4}$/
          options[symbol] = number.to_i
        else
          raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
        end
      end
    end
    
    status = (attr[:status] || 'published').downcase
    unless status == 'all'
      stat = Status[status]
      unless stat.nil?
        options[:conditions] = ["(virtual = ?) and (status_id = ?)", false, stat.id]
      else
        raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
      end
    else
      options[:conditions] = ["virtual = ?", false]
    end
    
    result = []
    current = tag.locals.page
    siblings = current.self_and_siblings
    tag.locals.previous_headers = {}
    siblings.find(:all, options).each do |item| next if item == current
      tag.locals.page = item 
      result << tag.expand
    end 
    result
  end
  
  desc %{ 
    Renders a list of links specified in the @urls@ attribute according to three
    states:
    
    * @normal@ specifies the normal state for the link
    * @here@ specifies the state of the link when the url matches the current
       page's URL
    * @selected@ specifies the state of the link when the current page matches
       is a child of the specified url
    
    The @between@ tag specifies what sould be inserted in between each of the links.
    
    *Usage:*
    <pre><code><r:navigation urls="[Title: url | Title: url | ...]">
      <r:normal><a href="<r:url />"><r:title /></a></r:normal>
      <r:here><strong><r:title /></strong></r:here>
      <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
      <r:between> | </r:between>
    </r:navigation>
    </code></pre>
  }
  tag 'navigation' do |tag|
    hash = tag.locals.navigation = {}
    tag.expand
    raise TagError.new("`navigation' tag must include a `normal' tag") unless hash.has_key? :normal
    result = []
    pairs = tag.attr['urls'].to_s.split('|').map do |pair|
      parts = pair.split(':')
      value = parts.pop
      key = parts.join(':')
      [key.strip, value.strip]
    end
    pairs.each do |title, url, slug|
      compare_url = remove_trailing_slash(url)
      page_url = remove_trailing_slash(self.url)
      hash[:title] = title
      hash[:url] = url
      hash[:slug] = title.gsub(/[^\w\.\-]/, '-').downcase
      case page_url
      when compare_url
        result << (hash[:here] || hash[:selected] || hash[:normal]).call
      when Regexp.compile( '^' + Regexp.quote(url))
        result << (hash[:selected] || hash[:normal]).call
      else
        result << hash[:normal].call
      end
    end
    between = hash.has_key?(:between) ? hash[:between].call : ' '
    result.join(between)
  end
  [:normal, :here, :selected, :between].each do |symbol|
    tag "navigation:#{symbol}" do |tag|
      hash = tag.locals.navigation
      hash[symbol] = tag.block
    end
  end
  [:title, :url, :slug].each do |symbol|
    tag "navigation:#{symbol}" do |tag|
      hash = tag.locals.navigation
      hash[symbol]
    end
  end
end