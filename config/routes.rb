ActionController::Routing::Routes.draw do |map|
  # See how all your routes lay out with "rake routes"
  map.root :controller => 'report', :action => 'index'
  map.show_report '/report/:id', :controller => 'report', :action => 'show'
  map.connect 'admin', :controller => 'admin', :action => 'login'
  map.connect 'admin/:permalink/reports/:action/:id.:format', :controller => 'admin/reports'
  map.connect 'admin/:permalink/reports/:action.:format', :controller => 'admin/reports'
  map.connect 'admin/:permalink/reports/:action/:id', :controller => 'admin/reports'

  map.connect 'admin/:permalink/mail_config/:action/:id.:format', :controller => 'admin/mail_config'
  map.connect 'admin/:permalink/mail_config/:action.:format', :controller => 'admin/mail_config'
  map.connect 'admin/:permalink/mail_config/:action/:id', :controller => 'admin/mail_config'

  map.connect 'report/index/sort/:sort', :controller => 'report', :action => 'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
