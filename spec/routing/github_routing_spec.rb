require 'rails_helper'

describe 'Github routing' do
  it 'routes to #search' do
    expect(get: '/github/search').to route_to(controller: 'github', action: 'search')
  end
end
