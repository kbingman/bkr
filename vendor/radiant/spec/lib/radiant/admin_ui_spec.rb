require File.dirname(__FILE__) + "/../../spec_helper"

describe Radiant::AdminUI do
  before :each do
    @admin = Radiant::AdminUI.instance
  end
  
  it "should be a Simpleton" do
    Radiant::AdminUI.included_modules.should include(Simpleton)
    Radiant::AdminUI.should respond_to(:instance)
  end
  
  it "should have a TabSet" do
    @admin.should respond_to(:tabs)
    @admin.tabs.should_not be_nil
    @admin.tabs.should be_instance_of(Radiant::AdminUI::TabSet)
  end
end

describe Radiant::AdminUI::TabSet do

  before :each do
    @tabs = Radiant::AdminUI::TabSet.new
    @tab_names = %w{First Second Third}
    @tab_names.each do |name|
      @tabs.add name, "/#{name.underscore}"
    end
  end

  it "should be Enumerable" do
    @tabs.class.included_modules.should include(Enumerable)
  end
  
  it "should have its tabs accessible by name using brackets" do
    @tabs.should respond_to(:[])
    @tab_names.each do |name|
      @tabs[name].should be_instance_of(Radiant::AdminUI::Tab)
      @tabs[name].name.should == name
    end
  end
  
  it "should have its tabs accessible by index using brackets" do
    @tab_names.each_with_index do |name, index|
      @tabs[index].should be_instance_of(Radiant::AdminUI::Tab)
      @tabs[index].name.should == name
    end 
  end
  
  it "should add new tabs to the end by default" do
    @tabs.size.should == 3
    @tabs.add "Test", "/test"
    @tabs[3].name.should == "Test"
  end
  
  it "should add a new tab before the specified tab" do
    @tabs[1].name.should == "Second"
    @tabs.add "Before", "/before", :before => "Second"
    @tabs[1].name.should == "Before"
    @tabs[2].name.should == "Second"
  end
  
  it "should add a new tab after the specified tab" do
    @tabs[1].name.should == "Second"
    @tabs[2].name.should == "Third"
    @tabs.add "After", "/after", :after => "Second"
    @tabs[2].name.should == "After"
    @tabs[1].name.should == "Second"
    @tabs[3].name.should == "Third"
  end
  
  it "should remove a tab by name" do
    @tabs.size.should == 3
    @tabs.remove "Second"
    @tabs.size.should == 2
    @tabs[1].name.should == "Third"
  end
  
  it "should not allow adding a tab with the same name as an existing tab" do
    lambda { @tabs.add "First", "/first" }.should raise_error(Radiant::AdminUI::DuplicateTabNameError)
  end
  
  it "should remove all tabs when cleared" do
    @tabs.size.should == 3
    @tabs.clear
    @tabs.size.should == 0
  end
end

describe Radiant::AdminUI::Tab do
  scenario :users

  before :each do
    @tab = Radiant::AdminUI::Tab.new "Test", "/test"
  end

  it "should be shown to all users by default" do
    @tab.visibility.should == [:all]
    [:existing, :another, :admin, :developer, :non_admin].each do |user|
      @tab.should be_shown_for(users(user))
    end
  end
  
  it "should be shown only to admin users when visibility is admin" do
    @tab.visibility = [:admin]
    @tab.should be_shown_for(users(:admin))
    [:existing, :another, :developer, :non_admin].each do |user|
      @tab.should_not be_shown_for(users(user))
    end
  end
  
  it "should be shown only to developer users when visibility is developer" do
    @tab.visibility = [:developer]
    @tab.should be_shown_for(users(:developer))
    [:existing, :another, :admin, :non_admin].each do |user|
      @tab.should_not be_shown_for(users(user))
    end    
  end
  
  it "should assign visibility from :for option when created" do
    @tab = Radiant::AdminUI::Tab.new "Test", "/test", :for => :developer
    @tab.visibility.should == [:developer]
  end
  
  it "should assign visibility from :visibility option when created" do
    @tab = Radiant::AdminUI::Tab.new "Test", "/test", :visibility => :developer
    @tab.visibility.should == [:developer]
  end
  
  it "should assign visibility from both :for and :visibility options when created" do
    @tab = Radiant::AdminUI::Tab.new "Test", "/test", :for => :developer, :visibility => :admin
    @tab.visibility.should == [:developer, :admin]
  end
end
