class Bullet < Figure
  PATH_TO_IMAGE = 'media/square_bullet.png'

  attr_accessor :collision_sym
  attr_reader :tank_owner
  def initialize(window, tank_owner)
    @collision_sym = tank_owner.is_a?(TankBot) ? :bot_bullet : :player_bullet
    super(window, tank_owner.x, tank_owner.y, PATH_TO_IMAGE, tank_owner.bullets)
    @tank_owner = tank_owner
    self.position = tank_owner.position
  end

end
