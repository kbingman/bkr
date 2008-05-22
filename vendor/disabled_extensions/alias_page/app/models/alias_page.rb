class AliasPage < Page
  description %{
    Causes a page to be an alias to another page.  The source is given in the
    "source" page part as a slug path (not the URL).

    However, the page will search it's own children before searching it's
    source's children.  This is to allow pages to override portions of it's
    destination (CSS files, for example).
  }

  def find_by_url(url, live = true, clean = false)
    url = clean_url(url) if clean

    # Find source
    source = part( :source ).content.strip
    source = find_by_path source if source
    return nil unless source or source != self

    if self.url == url && (not live or published?)
      # Route requests for this page to source page
      return source
    else
      # Find my children
      children.each do |child|
        if (url =~ Regexp.compile('^' + Regexp.quote(child.url))) and (not child.virtual?)
          found = child.find_by_url(url, live, clean)
          return found if found
        end
      end

      # Modify URL to source's URL
      url.sub!(Regexp.compile('^' + Regexp.quote(self.url)), source.url)
      
      # Let source handle it
      return source.find_by_url(url, live, clean)
    end
  end

  def find_by_path(path)
    return nil unless path # No path! Abort!

    path.gsub! %r{//+}, '/' # Remove dup /s
    path.gsub! %r{[^/]+/\.\.}, '' # Remove path/..

    # Catch root case
    if path.sub! %r{^/}, ''
      page = Page.root
    else
      # Begin relative to parent (if there is one)
      page = parent || self
    end

    path.split('/').each do |slug|
      case slug
      when '..'
        page = page.parent
      when '.'
        next
      else
        page = page.children.find_by_slug slug
      end

      break if page.nil? # Ran out of pages somewhere
    end

    return page
  end
end
