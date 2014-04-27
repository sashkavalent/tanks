class GameWindow < Gosu::Window
  attr_reader :borders
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "examples/media/Space.png", true)
    self.caption = "Gosu Tutorial Game"
    @player = Tank.new(self, width / 2, height / 2)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @borders = OpenStruct.new(top: 0, bottom: height,
      left: 0, right: width)

    @bots = []
    4.times { @bots << TankBot.new(self, rand(width), rand(height)) }
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

  private

  def update
    bullets_move
    bots_move
    player_move
  end

  def player_move
    case true
    when button_down?(Gosu::KbUp)
      @player.position = Position::TOP
    when button_down?(Gosu::KbDown)
      @player.position = Position::BOTTOM
    when button_down?(Gosu::KbLeft)
      @player.position = Position::LEFT
    when button_down?(Gosu::KbRight)
      @player.position = Position::RIGHT
    else
      stop = true
    end

    if !stop
      @player.move
    end
  end

  def bots_move
    @bots.each { |bot| bot.move }
  end

  def bullets_move
    @player.bullets.each { |bullet| bullet.move }
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @bots.each(&:draw)
    @player.bullets.each(&:draw)
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then close end
    if id == Gosu::KbSpace then @player.fire end
  end
end
