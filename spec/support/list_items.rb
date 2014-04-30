RSpec::Matchers.define(:list_items) do |items|
  match do |page|
    page.has_content?(Regexp.new(items.map { |item| "#{item.title} - #{item.artist}" }.join('.*')))
  end
end
