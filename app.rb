#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
		return SQLite3::Database.new 'barbershop.db'
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

