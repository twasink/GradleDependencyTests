require File.join(File.dirname(__FILE__), 'gradle_helper')

class CustomWorld
  include Twasink::GradleHelper

end

World do
  CustomWorld.new
end