module Constants
  EDGE_SIZE = 45
  TICK = 1.0/60.0
end

module ZOrder
  Background, Bullets, Tanks, UI = *0..3
end

module Position
  TOP = Math::PI / 2 * 3
  BOTTOM = Math::PI / 2
  LEFT = Math::PI
  RIGHT = 0
  # TOP = :top
  # BOTTOM = :bottom
  # LEFT = :left
  # RIGHT = :right
  LIST = [TOP, BOTTOM, LEFT, RIGHT]
end
