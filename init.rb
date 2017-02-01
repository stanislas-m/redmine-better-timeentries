Redmine::Plugin.register :better_timeentries do
  name 'Better Timeentries plugin'
  author 'Stanislas Michalak'
  description 'A plugin providing time entries in man hours.'
  version '0.0.1'

  menu :top_menu, :better_timeentries, { :controller => 'timeentries', :action => 'index' }, :caption => 'Imputations'
end
