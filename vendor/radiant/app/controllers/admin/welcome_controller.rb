class Admin::WelcomeController < ApplicationController
  no_login_required
  
  def index
    redirect_to page_index_url
  end
  
  def login
    if request.post?
      login = params[:user][:login]
      password = params[:user][:password]
      self.current_user = User.authenticate(login, password)
      if current_user
        redirect_to welcome_url
      else
        announce_invalid_user
      end
    end
  end
  
  def logout
    self.current_user = nil
    announce_logged_out
    redirect_to login_url
  end
  
  private
  
    def announce_logged_out
      flash[:notice] = 'You are now logged out.'
    end
    
    def announce_invalid_user
      flash[:error] = 'Invalid username or password.'
    end
    
end
