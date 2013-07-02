require './app'
require 'date'
require 'json'

desc "Fetch the last 7 days of data"
task :fetch do
  client = MovesAPI.new(nil).access_token
  profile = client.get('/api/v1/user/profile').parsed
  first_date = Date.parse(profile['profile']['firstDate'])

  (0..7).each do |i|
    date = Date.today - i
    break if first_date > date.to_date
    client = MovesAPI.new(nil).access_token
    data = client.get("/api/v1/user/storyline/daily/#{date.strftime('%Y-%m-%d')}?trackPoints=true").body
    record = MovesDay.first_or_create(:day => date)
    record.json = data
    record.save
  end
end
