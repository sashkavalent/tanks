module SetupWindow
  SCREEN_WIDTH = 640
  SCREEN_HEIGHT = 480

  private

  def set_caption
    self.caption = 'Server' if server?
    self.caption = 'Client' if client?
  end

  def setup_tanks
    @s_tank = Tank.new(self, width / 2, height / 2, @tanks)
    @c_tank = Tank.new(self, width / 2 + 50, height / 2, @tanks)
    dist = 100
    bots_places = [[dist, dist], [SCREEN_WIDTH - dist, dist],
      [SCREEN_WIDTH - dist, SCREEN_HEIGHT - dist], [dist, SCREEN_HEIGHT - dist]]
    bots = bots_places.map { |place| TankBot.new(self, place[0], place[1], @tanks) }
    @tanks << @c_tank << @s_tank
    @tanks.concat(bots)
  end

  def destroy_bullet(bullet_shape)
    bullet = find_figure_by_shape(bullet_shape)
    if bullet.present?
      tank_id = bullet.tank_owner.id
      @server_state['events'] <<
        { event_type: :destroy,
          data: { figure_type: :bullet, tank_id: tank_id, bullet_id: bullet.id }
        }
      bullet.destroy
    end
  end

  def destroy_tank_and_bullet(bullet_shape, tank_shape)
    @space.add_post_step_callback(bullet_shape) do |space, key|
      destroy_bullet(bullet_shape)
      tank = find_figure_by_shape(tank_shape)
      if tank.present?
        @server_state['events'] <<
          { event_type: :destroy,
            data: { figure_type: :tank, tank_id: tank.id }
          }
        tank.destroy
      end
    end
  end

  def setup_collisions
    @space.add_collision_func(Tank.to_sym, TankBot.to_sym) do |tank_shape, bot_shape|
      @score += 10
    end
    @space.add_collision_func(:player_bullet, Tank.to_sym) do |bullet_shape, bot_shape|
      false
    end
    @space.add_collision_func(:bot_bullet, TankBot.to_sym) do |bullet_shape, bot_shape|
      false
    end

    @space.add_collision_func(:wall, :bot_bullet) do |wall_shape, bullet_shape|
      @space.add_post_step_callback(bullet_shape) do |space, key|
        destroy_bullet(bullet_shape)
      end
    end
    @space.add_collision_func(:wall, :player_bullet) do |wall_shape, bullet_shape|
      @space.add_post_step_callback(bullet_shape) do |space, key|
        destroy_bullet(bullet_shape)
      end
    end

    @space.add_collision_func(:player_bullet, TankBot.to_sym) do |bullet_shape, tank_shape|
      destroy_tank_and_bullet(bullet_shape, tank_shape)
    end
    @space.add_collision_func(:bot_bullet, Tank.to_sym) do |bullet_shape, tank_shape|
      destroy_tank_and_bullet(bullet_shape, tank_shape)
    end

  end

  def find_figure_by_shape(shape)
    @tanks.map { |tank| [tank, tank.bullets] }.flatten.find { |figure| figure.shape == shape }
  end

  def setup_background
    background = Magick::Image.new(SCREEN_WIDTH, SCREEN_HEIGHT) do
      self.background_color = 'black'
    end
    setup_borders(background)
    @background_image = Gosu::Image.new(self, background, true)
  end

  BORDERS_INTERVAL = 5.0
  SCREEN_SIZE = SCREEN_WIDTH + SCREEN_HEIGHT - 2.0 * BORDERS_INTERVAL
  BORDERS_COUNT = 30.0
  BORDER_WIDTH = SCREEN_SIZE / BORDERS_COUNT - BORDERS_INTERVAL

  def setup_borders(background)
    gc = Magick::Draw.new
    gc.fill('gray')
    body = CP::Body.new(Float::MAX, Float::MAX)
    shape_vertices = Figure.straight_square_vertices(BORDER_WIDTH)
    distance = BORDER_WIDTH + BORDERS_INTERVAL
    (SCREEN_WIDTH / distance).round.times do |i|
      x = distance * i + BORDERS_INTERVAL + BORDER_WIDTH / 2
      y =  BORDER_WIDTH / 2 + BORDERS_INTERVAL
      create_border(body, shape_vertices, gc, x, y)
      y =  SCREEN_HEIGHT - BORDER_WIDTH / 2 - BORDERS_INTERVAL
      create_border(body, shape_vertices, gc, x, y)
    end
    (SCREEN_HEIGHT / distance).round.times do |i|
      y = distance * i + BORDERS_INTERVAL + BORDER_WIDTH / 2
      x =  BORDER_WIDTH / 2 + BORDERS_INTERVAL
      create_border(body, shape_vertices, gc, x, y)
      x =  SCREEN_WIDTH - BORDER_WIDTH / 2 - BORDERS_INTERVAL
      create_border(body, shape_vertices, gc, x, y)
    end
    gc.draw(background)
  end

  def create_border(body, shape_vertices, gc, x, y)
    shape = CP::Shape::Poly.new(body, shape_vertices, CP::Vec2.new(x, y))
    shape.e = 1
    shape.u = 1
    shape.collision_type = :wall
    @space.add_shape(shape)
    draw_vertices = shape_vertices.map { |v| [x + v.x, y + v.y] }.flatten
    gc.polygon(*draw_vertices)
  end
end
