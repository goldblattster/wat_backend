require 'sinatra'
require 'sinatra/reloader' if development?
require 'rest-client'
require 'nokogiri'


def send_contact_message(name, email, subject, body)
  RestClient.post "https://api:#{ENV["MAILGUN_KEY"]}"\
  "@api.mailgun.net/v3/mg.withoutatracegame.com/messages",
  :from => "Without A Trace <no-reply@withoutatracegame.com>",
  :to => "Without A Trace Team <withoutatracegame@gmail.com>",
  :subject => subject,
  :text => Nokogiri::HTML(body).text,
  :html => body,
  :'h:Reply-To' => "#{name} #{email}"
end

post '/contact' do
  name = params['name']
  email = params['email']
  subject = params['subject']
  body = params['body']
  
  response = send_contact_message name, email, subject, body

  if response.code == 200
    redirect to('http://withoutatracegame.com/contact/done'), 303
  else
    redirect to('http://withoutatracegame.com/contact/error'), 303
  end
end