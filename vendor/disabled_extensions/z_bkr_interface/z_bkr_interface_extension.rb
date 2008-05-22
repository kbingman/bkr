# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ZBkrInterfaceExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/z_bkr_interface"
  
  # define_routes do |map|
  #   map.connect 'admin/z_bkr_interface/:action', :controller => 'admin/z_bkr_interface'
  # end
  
  def activate
    # admin.tabs.add "Z Bkr Interface", "/admin/z_bkr_interface", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Z Bkr Interface"
  end
  
end