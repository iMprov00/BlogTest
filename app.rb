require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db

	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true

end

before do

	init_db

end

configure do 

	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "created_date" DATE, "content" TEXT);'

	@db.execute 'CREATE TABLE IF NOT EXISTS "Comment" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "created_date" DATE, "comment" TEXT, "post_id" INTEGER);'

end

get '/' do 

	@result = @db.execute 'SELECT * FROM Posts ORDER BY ID DESC'

	erb :index

end

get '/new' do

	erb :new

end

post '/new' do

	content = params[:content]

	if content.length <= 0
		@error = "Эй, ты ничего не написал!"
		return erb :new
	end

	@db.execute 'INSERT INTO Posts (content, created_date) VALUES (?,datetime())', [content]

	redirect to '/'

end

get '/post/:id' do  

	id = params[:id]

	@result = 	@result = @db.execute 'SELECT * FROM Posts WHERE id = ?', [id]
	@row = @result[0]
	@comment = @db.execute 'SELECT * FROM Comment WHERE post_id = ? ORDER BY ID DESC', [id]

	erb :post

end

post '/post/:id' do  

	id = params[:id]	
	content = params[:content]

	@db.execute 'INSERT INTO Comment (comment, created_date, post_id) VALUES (?, datetime(), ?)', [content, id]

	redirect to ('/post/' + id)
end