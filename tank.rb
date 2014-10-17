class Tank < Figure
  PATH_TO_IMAGE = 'media/green_tank.jpg'
  attr_reader :score, :bullets
  @@shot = nil

  def initialize(window, x, y, aggregator)
    super(window, x, y, PATH_TO_IMAGE, aggregator)
    @@shot = @@shot || Gosu::Sample.new(window, "media/shot.wav")
    @score = 0
    @bullets = []
    position = Position::TOP
  end

  def destroy
    super
    players = @aggregator.select { |tank| !(tank.is_a? TankBot) }
    bots = @aggregator.select { |tank| tank.is_a? TankBot }
    if bots.blank? || players.blank?
      @window.start_game_over_mode
    end
    @destroyed = true
  end

  def fire
    if !@destroyed
      @@shot.play
      if @window.server? && @window.multiplayer
        @window.server_state['events'] << { event_type: :fire, data: { tank_id: self.id } }
      end
      bullet = Bullet.new(@window, self)
      bullet
    end
  end

  def height
    @image.height
  end

end
