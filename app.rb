require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'oauth2'

DataMapper.setup(:default, ENV['DATABASE_URL'])

class MovesDay
  include DataMapper::Resource
  property :id,      Serial
  property :day,     DateTime
  property :json,    Text
end

DataMapper.auto_upgrade!

class MovesAPI

  attr_reader :request
  def initialize(request)
    @request = request
  end

  def client
    OAuth2::Client.new(
      ENV['MOVES_CLIENT_ID'],
      ENV['MOVES_CLIENT_SECRET'],
      :site => 'https://api.moves-app.com',
      :authorize_url => 'https://api.moves-app.com/oauth/v1/authorize',
      :token_url => 'https://api.moves-app.com/oauth/v1/access_token'
    )
  end

  def access_token
    OAuth2::AccessToken.new(client, ENV['MOVES_ACCESS_TOKEN'])
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/auth/moves/callback'
    uri.query = nil
    uri.to_s
  end    
  
end

class MovesBackupApp < Sinatra::Application

  before do
    @api = MovesAPI.new(request)
  end

  get "/" do
    unless ENV['MOVES_ACCESS_TOKEN']
      @moves_authorize_uri = @api.client.auth_code.authorize_url(:redirect_uri => @api.redirect_uri, :scope => 'activity location')
    end
    @days = MovesDay.all(:order => [:day.desc])
    erb :index
  end

  get '/day/:date' do
    @day = MovesDay.first(:day => params[:date])
    content_type 'application/json'
    @day.json
  end

  get '/auth/moves/callback' do
    @token = @api.client.auth_code.get_token(params[:code], :redirect_uri => @api.redirect_uri).token
    erb :display_token
  end
end

