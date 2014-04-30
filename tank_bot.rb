class TankBot < Tank
  PROBABILITY_OF_ROTATION = 0.02

  def move
    super
    if rand(1 / PROBABILITY_OF_ROTATION) == 0
      self.position = Position::LIST[rand(4)]
    end
  end

end
