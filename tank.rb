class Tank < Figure
  PATH_TO_IMAGE = 'media/tank.jpg'
  attr_reader :score, :bullets

  def initialize(window, x, y)
    super(window, x, y, PATH_TO_IMAGE)
    @beep = Gosu::Sample.new(window, 'examples/media/Beep.wav')

    @score = 0
    @bullets = []
    position = Position::TOP
  end

  def fire
    bullet = Bullet.new(@window, self)
    @bullets << bullet
    bullet
  end

end
