class Figure
  attr_reader :body, :shape

  def initialize(window, x, y, path_to_image)
    @window = window
    @image = Gosu::Image.new(window, path_to_image, false)
    get_in_shape(window.space, x, y)
  end

  def serialize
    { x: x, y: y, position: position}
  end

  def deserialize(serialized_info)
    @body.p.x, @body.p.y = serialized_info['x'], serialized_info['y']
    @body.a = serialized_info['position']
  end

  def reset_forces
    @body.reset_forces
  end

  def x
    @body.p.x
  end

  def y
    @body.p.y
  end

  def position=(pos)
    @body.a = pos if Position::LIST.include?(pos)
  end

  def position
    @body.a
  end

  def move
    @body.apply_force((@body.a.radians_to_vec2 * 500.0), CP::Vec2.new(0.0, 0.0))
    # @body.v = @body.a.radians_to_vec2 * 100.0
  end

  def draw
    @image.draw_rot(@body.p.x, @body.p.y, ZOrder::Tanks, @body.a.radians_to_gosu)
  end

  def self.to_sym
    to_s.underscore.to_sym
  end

  private

  def get_in_shape(space, x, y)
    tank_vertices = @window.straight_square_vertices(@image.height)
    @body = CP::Body.new(1, CP::moment_for_poly(Float::MAX, tank_vertices, CP::Vec2.new(0, 0))) #mass, moment of inertia
    @body.p = CP::Vec2.new(x, y)
    @shape = CP::Shape::Poly.new(@body, tank_vertices, CP::Vec2.new(0, 0))
    @shape.e = 1
    @shape.u = 1
    @shape.collision_type = self.class.to_sym
    space.add_body(@body)
    space.add_shape(@shape)
  end

end
