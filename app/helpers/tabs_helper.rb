module TabsHelper
  ##
  # activeTab => the index to make a tab active (starts at 0), OR
  #              the name of the tab as specified in `tabNames` (case insensitive)
  # tabNames => an array of String containing the tab names, ex. ["Products", "About"]
  ##
  def create_main_tabs(activeTab, tabNames , callback)
    if activeTab.class == String
      tab_index =  nil
      tabNames.each_with_index do |tab_name,index|
        if tab_name.casecmp(activeTab) == 0
          tab_index = index
          break
        end
      end
      
      raise "create_main_tab error: You specify string as activeTab but it's not part of tabNames" if tab_index.nil?
    end
    render :partial => 'shared/main_tabs', :locals => {:activeTab => activeTab, :tabNames => tabNames, :callback => callback}
  end
end