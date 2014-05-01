class GameWindow < Gosu::Window
  SCREEN_WIDTH = 640
  SCREEN_HEIGHT = 480
  TICK = 1.0/60.0

  attr_reader :borders, :space
  attr_accessor :server, :client
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Yearly 8"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @score = 0
    @space = CP::Space.new
    @space.damping = 0.2

    setup_background
    setup_tanks
    setup_collisions
  end

  def straight_square_vertices(size)
    vertices = []
    sides_number = 4
    angle_first = - Math::PI / sides_number
    sides_number.times do |i|
      angle = angle_first - 2 * Math::PI * i / sides_number
      vertices << angle.radians_to_vec2() * size / 2 / Math::cos(-angle_first)
    end
    return vertices
  end

  private

  def client?
    !!@server
  end

  def server?
    !!@client
  end

  def setup_tanks
    @player = Tank.new(self, width / 2, height / 2)
    @friend = Tank.new(self, width / 2 + 50, height / 2)
    dist = 100
    bots_places = [[dist, dist], [SCREEN_WIDTH - dist, dist],
      [SCREEN_WIDTH - dist, SCREEN_HEIGHT - dist], [dist, SCREEN_HEIGHT - dist]]
    @bots = bots_places.map { |place| TankBot.new(self, place[0], place[1]) }
  end

  def setup_collisions
    @space.add_collision_func(Tank.to_sym, TankBot.to_sym) do |tank_shape, bot_shape|
      @score += 10
    end
    @space.add_collision_func(Tank.to_sym, Bullet.to_sym) do |tank_shape, bullet_shape|
      false
    end

    @space.add_collision_func(:wall, Bullet.to_sym) do |wall_shape, bullet_shape|
      @space.add_post_step_callback(bullet_shape) do |space, key|
        delete_figure_from_array(bullet_shape, @player.bullets)
      end
    end

    @space.add_collision_func(Bullet.to_sym, TankBot.to_sym) do |bullet_shape, bot_shape|
      @space.add_post_step_callback(bullet_shape) do |space, key|
        delete_figure_from_array(bullet_shape, @player.bullets)
        delete_figure_from_array(bot_shape, @bots)
      end
    end

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
    shape_vertices = straight_square_vertices(BORDER_WIDTH)
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

  def delete_figure_from_array(figure_shape, array)
    figure = array.find { |figure| figure.shape == figure_shape }
    @space.remove_shape(figure.shape)
    @space.remove_body(figure.body)
    array.delete(figure)
  end

  def global_state
    @global_state || {}
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

  def update
    @space.step(Constants::TICK)
    if server?
      state = {}
      state['player'] = @player.serialize
      state['friend'] = @friend.serialize
      state['bots'] = @bots.map(&:serialize)

      @client.puts(state.to_json)
      @global_state = JSON.parse(@client.gets)
      bullets_move
      bots_move
      players_move
    elsif client?
      state = JSON.parse(@server.gets)
      @friend.deserialize(state['player'])
      @player.deserialize(state['friend'])
      @bots.each.with_index { |bot, i| bot.deserialize(state['bots'][i]) }
      players_move
      @server.puts global_state.to_json
    end
  end

  def players_move
    if server?
      case go = true
      when button_down?(Gosu::KbUp)
        @player.position = Position::TOP
      when button_down?(Gosu::KbDown)
        @player.position = Position::BOTTOM
      when button_down?(Gosu::KbLeft)
        @player.position = Position::LEFT
      when button_down?(Gosu::KbRight)
        @player.position = Position::RIGHT
      else
        go = false
      end
      @player.reset_forces
      @player.move if go

      go = true
      case global_state['key']
      when 'up' then @friend.position = Position::TOP
      when 'down' then @friend.position = Position::BOTTOM
      when 'left' then @friend.position = Position::LEFT
      when 'right' then @friend.position = Position::RIGHT
      else
        go = false
      end
      @friend.reset_forces
      @friend.move if go

    elsif client?
      key = case (go = true)
      when button_down?(Gosu::KbUp) then 'up'
      when button_down?(Gosu::KbDown) then 'down'
      when button_down?(Gosu::KbLeft) then 'left'
      when button_down?(Gosu::KbRight) then 'right'
      else
        go = false
        nil
      end
      @global_state = global_state
      @global_state['key'] = key if go
    end
  end

  def bots_move
    @bots.each do |bot|
      bot.reset_forces
      bot.move
    end
  end

  def bullets_move
    @player.bullets.each(&:move)
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @friend.draw
    @bots.each(&:draw)
    @player.bullets.each(&:draw)
    @font.draw("Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then close end
    if id == Gosu::KbSpace then @player.fire end
    if id == Gosu::KbLeftControl then binding.pry end
  end
end
