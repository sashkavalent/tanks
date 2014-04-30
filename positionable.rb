module Positionable

  def angle
    case @position
    when Position::TOP then 0
    when Position::BOTTOM then 180
    when Position::LEFT then 270
    when Position::RIGHT then 90
    end
  end

end
