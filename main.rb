require 'rubygems'
require 'gosu'
require 'pry'
require 'chipmunk'
require 'RMagick'
require_relative 'game_window'
require_relative 'positionable'
require_relative 'bullet'
require_relative 'tank'
require_relative 'tank_bot'
require_relative 'constants'

window = GameWindow.new
window.show
