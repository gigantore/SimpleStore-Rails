if Rack::Utils.respond_to?("key_space_limit=")
  Rack::Utils.key_space_limit = 10485760  #limit to 10MB
  #262144   
end