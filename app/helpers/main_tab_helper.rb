module MainTabHelper
=begin
 This is a server solution for creating maintab. Originally I used my custom statictabs.js but apparently if there's JS error it won't show you  
  the line number *sucks*
  
 Anyhow, this requires jquery-ui so make sure you have that included somewhere!
 
 The main div ID is "main_tab"
=end
 
 
  ##
  # Params
  # => tab_display_names
  # => tab_urls
  # => selected
  #
  ##
  def main_tab_open ( options )
      tab_display_names = options[:tab_display_names]
      tab_urls = options[:tab_urls]
      selected = options[:selected]
    
      raise "tab_display_names and tab_urls must be of same length" if tab_display_names.length != tab_urls.length
      
      base_class = "ui-state-default ui-corner-top"; 
      selected_class = base_class + " ui-tabs-selected ui-state-active";
    
      tabs = '<div id="main_tab" class="ui-tabs ui-widget ui-widget-content ui-corner-all" ><ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">';
      
      tab_display_names.each_with_index do |tab_name, index|
         url = tab_urls[index]
         cls = base_class
         cls = selected_class if index == selected
         
         tabs += '<li class="'+cls+'"><a href="'+url+'">'+tab_name+'</a></li>';
      end
      
      tabs += '</ul><div class="ui-tabs-panel ui-widget-content ui-corner-bottom" ><p>' 
        
      
      return raw tabs
  end
  
  def main_tab_close
      return raw '</p></div></div>'
  end
end
