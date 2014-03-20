$:.push *Dir[File.join(File.expand_path('../../app', __FILE__), '/*/')]

RSpec.configure do |config|
  config.order = 'random'
end
