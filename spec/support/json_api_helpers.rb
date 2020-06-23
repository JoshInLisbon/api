# see rails_helper.rb in spec
# other helpers should be in support folder and not end with _spec.rb
# also need to comment out line in rails_helper to load that folder

module JsonApiHelpers
  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end
end
