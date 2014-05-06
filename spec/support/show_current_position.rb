RSpec::Matchers.define(:show_current_position) do |position|
  match do |page|
    page.has_selector?("li:nth-of-type(#{position + 1}).current-position")
  end
end
