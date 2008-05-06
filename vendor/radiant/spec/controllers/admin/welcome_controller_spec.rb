require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::WelcomeController do
  scenario :users
  
  it "should redirect to page tree on get to /admin/welcome" do
    get :index
    response.should be_redirect
    response.should redirect_to(page_index_url)
  end
  
  it "should render the login screen on get to /admin/login" do
    get :login
    response.should be_success
    response.should render_template("login")
  end
  
  it "should set the current user and redirect when login was successful" do
    post :login, :user => {:login => "admin", :password => "password"}
    controller.send(:current_user).should == users(:admin)
    response.should be_redirect
    response.should redirect_to(welcome_url)
  end
  
  it "should render the login template when login failed" do
    post :login, :user => {:login => "admin", :password => "wrong"}
    response.should render_template("login")
    flash[:error].should_not be_nil
  end
  
  it "should clear the current user and redirect on logout" do
    controller.should_receive(:current_user=).with(nil)
    get :logout
    response.should be_redirect
    response.should redirect_to(login_url)
  end
end