class Bullet < Figure
  PATH_TO_IMAGE = 'media/square_bullet.png'

  def initialize(window, tank_owner)
    super(window, tank_owner.x, tank_owner.y, PATH_TO_IMAGE)
    @tank_owner = tank_owner
    self.position = tank_owner.position
  end

  def destroy
    super
    @tank_owner.bullets.delete(self)
  end

end
