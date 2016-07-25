#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
		db = SQLite3::Database.new 'barbershop.db'
		db.results_as_hash = true
		return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT
		)'

	seed_db db, ['Walter White', 'Jessie Pinkman', 'Gus Fring', 'Mike Ehrmantraut']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error='Something wrong'
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@name=params[:username]
	@phone=params[:phone]
	@datetime=params[:datetime]
	@barber=params[:barber]
	@color=params[:color]

	hh = { :username => "Введите имя",
	    :phone => "Введите телефон",
	    :datetime => "Введите дату и время"
	}

	hh.each do |key, value|
		if params[key]==''
			@error=hh[key]
			return erb :visit
			
		end
	end 
	db = get_db
	db.execute 'insert into Users (username, phone, datestamp, barber, color) VALUES (?, ?, ?, ?, ?)',
	[@name, @phone, @datetime, @barber, @color]



	#f=File.open './public/users.txt', 'a'
	#f.write "User: #{@name}, Phone: #{@phone}, Datetime: #{@datetime}, Hairdresser: #{@hairdresser}, Color: #{@color}\n"
	#f.close

	erb :thanks

	
end



post '/contacts' do
	

	@email=params[:email]
	@message=params[:message]

	hh = { :email => "Введите email",
	    :message => "Введите сообщение",
	}

	hh.each do |key, value|
		if params[key]==''
			@error=hh[key]
			return erb :contacts
			
		end
	end




	f1=File.open './public/contacts.txt', 'a'
	f1.write "Email: #{@email}, Message: #{@message}\n"
	f1.close

	erb :thanks
end

get '/showusers' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'
   erb :showusers
end

