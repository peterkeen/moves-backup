require './app'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  return true unless ENV['USERNAME'] && ENV['PASSWORD']
  ENV['USERNAME'] == username && ENV['PASSWORD'] == password
end

run MovesBackupApp
