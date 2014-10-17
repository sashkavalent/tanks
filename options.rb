class Options

  def initialize(window)
    @window = window
    @start_pos_y = window.height / 8
    @start_pos_x = window.width / 15
    @points_shift = window.height / 12

    @font = Gosu::Font.new(window, Constants::FONT_PATH, 55)
    @description = ['В данной  игре  необходимо,', 'управляя  персонажем,  уни-', 'чтожить все вражеские танки.', 'Игра  поддерживает  сетевой', 'режим.  Для  игры  в этом ре-', 'жиме клиент должен указать', 'IP сервера. Когда оба игрока',  'введут клавишу Enter, игра', 'начнется.']
    # @font = Gosu::Font.new(window, '/usr/share/fonts/truetype/freefont/FreeSans.ttf', 50)
  end

  def draw
    @description.each.with_index do |desc, i|
      @font.draw(desc, @start_pos_x, @start_pos_y + @points_shift * i, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    end
  end

  def button_down(id)
    case id
    when Gosu::KbEscape, Gosu::KbReturn then @window.start_menu_mode
    end
  end

end
