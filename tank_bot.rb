class TankBot < Tank
  PROBABILITY_OF_ROTATION = 0.02
  PROBABILITY_OF_FIRE = 0.01

  def move
    super
    if rand(1 / PROBABILITY_OF_ROTATION) == 0
      self.position = Position::LIST[rand(4)]
    end
    if rand(1 / PROBABILITY_OF_FIRE) == 0
      self.fire
    end
  end

end
