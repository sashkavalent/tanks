class TankBot < Tank
  PROBABILITY_OF_ROTATION = 0.02

  def move
    super
    if rand(1 / PROBABILITY_OF_ROTATION) == 0
      self.position = case rand(4)
      when 0 then Position::TOP
      when 1 then Position::BOTTOM
      when 2 then Position::LEFT
      when 3 then Position::RIGHT
      end
    end
  end

end
