require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do 

	erb :index

end

get '/new' do

	erb :new

end

post '/new' do

	content = params[:content]

	erb "Вы ввели #{content}"

end