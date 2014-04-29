RSpec::Matchers.define(:have_playlist) do |playlist|
  match do |page|
    page.has_content?(Regexp.new(playlist.items.map { |item| "#{item.title} - #{item.artist}" }.join('.*')))
  end
end
