RSpec::Matchers.define(:show_now_playing) do |item|
  match do |page|
    page.has_content?(/now playing: #{item.title} - #{item.artist}/i)
  end
end
