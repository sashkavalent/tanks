class Tank
  include Positionable
  PATH_TO_IMAGE = 'media/tank.jpg'

  attr_reader :score, :bullets
  attr_accessor :position, :shape, :body

  def initialize(window, x, y)
    @window = window

    @image = Gosu::Image.new(window, PATH_TO_IMAGE, false)
    @beep = Gosu::Sample.new(window, 'examples/media/Beep.wav')

    @speed = 2
    @score = 0
    @bullets = []
    @position = Position::TOP
    get_in_shape(window.space, x, y)
  end

  def fire
    @bullets << Bullet.new(@window, self)
  end

  def x
    @body.p.x
  end

  def y
    @body.p.y
  end

#такой же метод есть в bullet.rb
#сделать модуль с этим методом. в нем yeild. в него передавать блок
  def move
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * 500.0), CP::Vec2.new(0.0, 0.0))
    # case @position
    # when Position::TOP
    #   @body.p.y -= @speed if @window.free_space?(@body.p.x, @body.p.y - @image.height / 2, @position)
    # when Position::BOTTOM
    #   @body.p.y += @speed if @window.free_space?(@body.p.x, @body.p.y + @image.height / 2, @position)
    # when Position::LEFT
    #   @body.p.x -= @speed if @window.free_space?(@body.p.x - @image.width / 2, @body.p.y, @position)
    # when Position::RIGHT
    #   @body.p.x += @speed if @window.free_space?(@body.p.x + @image.width / 2, @body.p.y, @position)
    # end
  end

  def draw
    # @image.draw_rot(@x, @y, ZOrder::Tanks, angle)
    @image.draw_rot(@body.p.x, @body.p.y, ZOrder::Tanks, @body.a.radians_to_gosu)
  end

  private

  def get_in_shape(space, x, y)
    tank_vertices = @window.straight_square_vertices(@image.height)

    # @image = @window.polygon_image(tank_vertices)

    @body = CP::Body.new(1, CP::moment_for_poly(10_000_000.0, tank_vertices, CP::Vec2.new(0, 0))) #mass, moment of inertia
    @body.p = CP::Vec2.new(x, y)#(rand(SCREEN_WIDTH), rand(40) - 50)
    @shape = CP::Shape::Poly.new(@body, tank_vertices, CP::Vec2.new(0, 0))
    @shape.e = 1
    @shape.u = 1
    @shape.collision_type = :tank
    space.add_body(@body)
    space.add_shape(@shape)
  end

end
