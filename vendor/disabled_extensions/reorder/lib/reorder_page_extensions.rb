module ReorderPageExtensions
  def included(page_base)
    page_base.send(:before_create, :update_position)
    page_base.class_eval <<-'end;'
      class InvalidAttribute < StandardError
        def initialize(attribute)
          super("invalid Page attribute `#{attribute}'")
        end
      end
    end;
  end
    
  def next(by = :position)
    options = {}
    ensure_valid_attribute(by)
    options[:order] = "#{by} ASC"
    options[:conditions] = ["#{by} > ?", read_attribute(by)]
    add_same_parent_condition(options)
    Page.find(:first, options)
  end
  
  def previous(by = :position)
    options = {}
    ensure_valid_attribute(by)
    options[:conditions] = ["#{by} < ?", read_attribute(by)]
    options[:order] = "#{by} DESC"
    add_same_parent_condition(options)
    Page.find(:first, options)
  end
  
  def first?(by = :position)
    options = {}
    ensure_valid_attribute(by)
    options[:order] = "#{by} ASC"
    add_same_parent_condition(options)
    Page.find(:first, options).id == id
  end
  
  def last?(by = :position)
    options = {}
    ensure_valid_attribute(by)
    options[:order] = "#{by} DESC"
    add_same_parent_condition(options)
    Page.find(:first, options).id == id
  end
  
  def update_position
    last = Page.find(:first, :conditions => { :parent_id => parent_id }, :order => 'position DESC')
    write_attribute('position', last.position + 1) if last
    true
  end
  
  private
  
    def ensure_valid_attribute(attribute)
      raise InvalidAttribute.new(attribute) unless attribute_names.include?(attribute.to_s)
    end
  
    def combine_conditions(a, b)
      a, b = a.dup, b.dup
      string = [a.shift, b.shift].compact.join(" AND ")
      conditions = a + b
      conditions.unshift(string)
    end
  
    def add_same_parent_condition(options)
      conditions = options[:conditions] || []
      conditions = combine_conditions(conditions, ["parent_id = ?", parent_id])
      options[:conditions] = conditions
    end

end