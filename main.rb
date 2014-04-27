require 'rubygems'
require 'gosu'
require 'pry'
require_relative 'game_window'
require_relative 'bullet'
require_relative 'tank'
require_relative 'tank_bot'

module ZOrder
  Background, Bullets, Tanks, UI = *0..3
end

module Position
  TOP = :top
  BOTTOM = :bottom
  LEFT = :left
  RIGHT = :right
end

window = GameWindow.new
window.show
