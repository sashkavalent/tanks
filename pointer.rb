class Pointer
  PATH_TO_IMAGE = 'media/tank.jpg'
  PATH_TO_SAMPLE = 'media/miss.wav'
  attr_reader :position

  def initialize(window, x, y_start_pos, shift, points_count)
    @image = Gosu::Image.new(window, PATH_TO_IMAGE, false)
    @y_start_pos = y_start_pos + @image.height - 17
    @x, @shift, @points_count = x, shift, points_count
    @position = 0
    @sample = Gosu::Sample.new(window, "media/miss.wav")
  end

  def up
    @position = (@position - 1 + @points_count) % @points_count
    @sample.play
  end

  def down
    @position = (@position + 1) % @points_count
    @sample.play
  end

  def draw
    @image.draw_rot(@x, y_pos, ZOrder::Tanks, 90)
  end

  private

  def y_pos
    @y_start_pos + @shift * @position
  end

end
