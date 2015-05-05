#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
set :bind, '0.0.0.0'

get "/" do
  "hello world"
end

get "/foo" do
  "<h1>foobar</h1>"
end