class IpInput
  def initialize(window)
    @window = window
    @message = 'Введите IP адрес сервера и нажмите Enter.'
    @font = Gosu::Font.new(@window, Constants::FONT_PATH, 30)
    @start_pos_y = window.height / 6
    @start_pos_x = window.width / 3
    @text_field = TextField.new(@window, @font, window.width / 2 - 50, @start_pos_y + 100)
    @window.text_input = @text_field
  end

  def draw
    @text_field.draw
    @font.draw(@message, @start_pos_x - 120, @start_pos_y, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      @window.start_menu_mode
      @window.text_input = nil
    when Gosu::KbReturn
      if @window.text_input.text.present?
        @window.wait(5) do
          start_game = true
          begin
            server = TCPSocket.open(@window.text_input.text, Constants::PORT)
          rescue Errno::ECONNREFUSED => e
            # sleep 1
            retry
          rescue Errno::EINVAL, Errno::ENETUNREACH, SocketError => e
            start_game = false
            @message = 'Неверный IP адрес, попробуйте еще раз.'
          rescue Exception => e
            binding.pry
          end
          if start_game
            @window.server = server
            @window.start_game_mode(true)
            @window.text_input = nil
          end
        end
      end
    end
  end

end
