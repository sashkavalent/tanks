class Tank
  PATH_TO_IMAGE = 'media/tank.jpg'

  attr_reader :score, :bullets
  attr_accessor :x, :y, :position

  def initialize(window, x, y)
    @x, @y = x, y
    @window = window

    @image = Gosu::Image.new(window, PATH_TO_IMAGE, false)
    @beep = Gosu::Sample.new(window, 'examples/media/Beep.wav')

    @angle = 0
    @speed = 3
    @score = 0
    @bullets = []
    @position = Position::TOP
  end

  def fire
    @bullets << Bullet.new(@window, self)
  end

#такой же метод есть в bullet.rb
#сделать модуль с этим методом. в нем yeild. в него передавать блок
  def move
    case @position
    when Position::TOP
      @angle = 0
      @y -= @speed if @window.free_space?(@x, @y - @image.height / 2, @position)
    when Position::BOTTOM
      @angle = 180
      @y += @speed if @window.free_space?(@x, @y + @image.height / 2, @position)
    when Position::LEFT
      @angle = 270
      @x -= @speed if @window.free_space?(@x - @image.width / 2, @y, @position)
    when Position::RIGHT
      @angle = 90
      @x += @speed if @window.free_space?(@x + @image.width / 2, @y, @position)
    end
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Tanks, @angle)
  end
end
