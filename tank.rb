class Tank < Figure
  PATH_TO_IMAGE = 'media/tank.jpg'
  attr_reader :score, :bullets

  def initialize(window, x, y, aggregator)
    super(window, x, y, PATH_TO_IMAGE, aggregator)
    @beep = Gosu::Sample.new(window, 'examples/media/Beep.wav')

    @score = 0
    @bullets = []
    position = Position::TOP
  end

  def fire
    @window.server_state['events'] << { event_type: :fire, data: { tank_id: self.id } }
    bullet = Bullet.new(@window, self)
    @bullets << bullet
    bullet
  end

end
