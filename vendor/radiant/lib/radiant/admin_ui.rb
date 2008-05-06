require 'simpleton'

module Radiant
  class AdminUI
    
    class DuplicateTabNameError < StandardError; end
    
    class Tab
      attr_accessor :name, :url, :visibility
      
      def initialize(name, url, options = {})
        @name, @url = name, url
        @visibility = [options[:for], options[:visibility]].flatten.compact
        @visibility = [:all] if @visibility.empty?
      end
      
      def shown_for?(user)
        visibility.include?(:all) or
          visibility.any? { |role| user.send("#{role}?") }
      end  
    end
    
    class TabSet
      def initialize
        @tabs = []
      end
    
      def add(name, url, options = {})
        options.symbolize_keys!
        before = options.delete(:before)
        after = options.delete(:after)
        tab_name = before || after
        if self[name]
          raise DuplicateTabNameError.new("duplicate tab name `#{name}'")
        else
          if tab_name
            index = @tabs.index(self[tab_name])
            index += 1 if before.nil?
            @tabs.insert(index, Tab.new(name, url, options))
          else
            @tabs << Tab.new(name, url, options)
          end
        end
      end
      
      def remove(name)
        @tabs.delete(self[name])
      end
      
      def size
        @tabs.size
      end
      
      def [](index)
        if index.kind_of? Integer
          @tabs[index]
        else
          @tabs.find { |tab| tab.name == index }
        end
      end
      
      def each
        @tabs.each { |t| yield t }
      end
      
      def clear
        @tabs.clear
      end
      
      include Enumerable
    end
    
    include Simpleton
    
    attr_accessor :tabs
    
    def initialize
      @tabs = TabSet.new
    end
    
  end
end