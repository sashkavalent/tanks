module Constants
  EDGE_SIZE = 45
  TICK = 1.0/60.0
  PORT = 2000
  HOSTNAME = '127.0.0.1'
  FONT_PATH = '/usr/share/fonts/comic.ttf'
end

module ZOrder
  Background, Bullets, Tanks, UI = *0..3
end

module Position
  TOP = Math::PI / 2 * 3
  BOTTOM = Math::PI / 2
  LEFT = Math::PI
  RIGHT = 0
  LIST = [TOP, BOTTOM, LEFT, RIGHT]
end
