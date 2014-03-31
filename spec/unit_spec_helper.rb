$:.push File.join(File.expand_path('../../lib', __FILE__))
$:.push File.join(File.expand_path('../../lib/dabster', __FILE__))

RSpec.configure do |config|
  config.order = 'random'
end
