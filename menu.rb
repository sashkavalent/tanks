class Menu
  attr_reader :pointer
  MENU_POINTS = ['1 игрок', '2 игрока (сервер)', '2 игрока (клиент)', 'Описание', 'Выход']

  def initialize(window)
    @window = window
    @start_pos_y = window.height / 8
    @start_pos_x = window.width / 3
    @points_shift = window.height / 6

    @pointer = Pointer.new(window, @start_pos_x - 50, @start_pos_y, @points_shift, MENU_POINTS.count)
    @font = Gosu::Font.new(window, Constants::FONT_PATH, 55)
    # @font = Gosu::Font.new(window, '/usr/share/fonts/truetype/freefont/FreeSans.ttf', 50)
  end

  def select
    case @pointer.position
    when 0 then @window.start_game_mode(false)
    when 1 then @window.start_server_mode
    when 2 then @window.start_client_mode
    when 3 then @window.start_options_mode
    when 4 then @window.close
    end
  end

  def draw
    MENU_POINTS.each.with_index do |menu_point, i|
      @font.draw(menu_point, @start_pos_x, @start_pos_y + @points_shift * i, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    end
    @pointer.draw
  end

  def button_down(id)
    case id
    when Gosu::KbUp then @pointer.up
    when Gosu::KbDown then @pointer.down
    when Gosu::KbReturn then select
    when Gosu::KbEscape then @window.close
    end
  end

end
