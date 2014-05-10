class Bullet < Figure
  PATH_TO_IMAGE = 'media/square_bullet.png'
  SPEED = 400.0

  attr_accessor :collision_sym
  attr_reader :tank_owner
  def initialize(window, tank_owner)
    @collision_sym = tank_owner.is_a?(TankBot) ? :bot_bullet : :player_bullet
    super(window, tank_owner.x, tank_owner.y, PATH_TO_IMAGE, window.bullets)
    @tank_owner = tank_owner
    self.position = tank_owner.position
    @body.p += @body.a.radians_to_vec2 * tank_owner.height / 2
  end

  def move
    @body.v = @body.a.radians_to_vec2 * SPEED
  end

end
