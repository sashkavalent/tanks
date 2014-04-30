class Numeric
   def radians_to_vec2
       CP::Vec2.new(Math::cos(self), Math::sin(self))
   end
end
class GameWindow < Gosu::Window
  SCREEN_WIDTH = 640
  SCREEN_HEIGHT = 480
  TICK = 1.0/60.0

  attr_reader :borders, :space
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    # @background_image = Gosu::Image.new(self, "examples/media/Space.png", true)
    self.caption = "Gosu Tutorial Game"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @borders = OpenStruct.new(top: 0, bottom: height,
      left: 0, right: width)

    @bots = []
    # 4.times { @bots << TankBot.new(self, rand(width), rand(height)) }
    @space = CP::Space.new
    @score = 0
    @space.add_collision_func(:tank, :tank) do |tank_1, tank_2|
      @score += 10
    end
       # fill = Magick::TextureFill.new(Magick::ImageList.new("black:"))
       background = Magick::Image.new(SCREEN_WIDTH, SCREEN_HEIGHT) { self.background_color = 'black'}
       setup_borders(background)
       @background_image = Gosu::Image.new(self, background, true) # turn the image into a Gosu one
    @player = Tank.new(self, width / 2, height / 2)
    dist = 100
    bots_places = [[dist, dist], [SCREEN_WIDTH - dist, dist],
      [SCREEN_WIDTH - dist, SCREEN_HEIGHT - dist], [dist, SCREEN_HEIGHT - dist]]
    @bots = bots_places.map { |place| TankBot.new(self, place[0], place[1]) }
  end

  def free_space?(x, y, direction)
    case direction
    when Position::TOP
      return false if y < @borders.top
    when Position::BOTTOM
      return false if y > @borders.bottom
    when Position::LEFT
      return false if x < @borders.left
    when Position::RIGHT
      return false if x > @borders.right
    end
    true
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

  # Produces the image of a polygon.
  # def polygon_image(vertices)
  #   box_image = Magick::Image.new(Constants::EDGE_SIZE  * 2, Constants::EDGE_SIZE * 2) { self.background_color = 'transparent' }
  #   gc = Magick::Draw.new
  #   gc.stroke('red')
  #   gc.fill('plum')
  #   shift = Constants::EDGE_SIZE / Math.sqrt(2)
  #   draw_vertices = vertices.map { |v| [v.x + shift, v.y + shift] }.flatten
  #   # draw_vertices = vertices
  #   # gc.rotate(45)
  #   gc.polygon(*draw_vertices)
  #   gc.draw(box_image)
  #   return Gosu::Image.new(self, box_image, false)
  # end
  private
  BORDERS_INTERVAL = 5.0
  SCREEN_SIZE = SCREEN_WIDTH + SCREEN_HEIGHT - 2.0 * BORDERS_INTERVAL
  BORDERS_COUNT = 66.0
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

  def create_border(body, shape_vertices, gc, x, y)
    shape = CP::Shape::Poly.new(body, shape_vertices, CP::Vec2.new(x, y))
    shape.e = 1
    shape.u = 1
    @space.add_shape(shape)
    draw_vertices = shape_vertices.map { |v| [x + v.x, y + v.y] }.flatten
    gc.polygon(*draw_vertices)
  end

  def update
    @space.step(Constants::TICK)
    bullets_move
    # bots_move
    player_move
  end

  def player_move
    case go = true
    when button_down?(Gosu::KbUp)
      @player.body.a = Position::TOP
    when button_down?(Gosu::KbDown)
      @player.body.a = Position::BOTTOM
    when button_down?(Gosu::KbLeft)
      @player.body.a = Position::LEFT
    when button_down?(Gosu::KbRight)
      @player.body.a = Position::RIGHT
    else
      go = false
    end
    @player.shape.body.reset_forces
    @player.move if go
  end

  def bots_move
    @bots.each do |bot|
      bot.move
      bot.shape.body.reset_forces
    end
  end

  def bullets_move
    @player.bullets.each { |bullet| bullet.move }
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @bots.each(&:draw)
    @player.bullets.each(&:draw)
    @font.draw("Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then close end
    if id == Gosu::KbSpace then binding.pry;@player.fire end
  end
end
