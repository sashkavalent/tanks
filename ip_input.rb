class IpInput
  def initialize(window)
    @window = window
    font = Gosu::Font.new(@window, Constants::FONT_PATH, 20)
    @start_pos_y = window.height / 8
    @start_pos_x = window.width / 3

    @text_field = TextField.new(@window, font, @start_pos_x, @start_pos_y)
    @window.text_input = @text_field
    # @text_fields = Array.new(3) { |index| TextField.new(@window, font, 50, 30 + index * 50) }
    # @cursor = Gosu::Image.new(@window, "media/Cursor.png", false)
  end

  def draw
    @text_field.draw
    # @text_fields.each { |tf| tf.draw }
    # @cursor.draw(@window.mouse_x, @window.mouse_y, 0)
  end

  def button_down(id)
    case id
    # when Gosu::KbTab
    #   # Tab key will not be 'eaten' by text fields; use for switching through
    #   # text fields.
    #   index = @text_fields.index(@window.text_input) || -1
    #   @window.text_input = @text_fields[(index + 1) % @text_fields.size]
    when Gosu::KbEscape
      # Escape key will not be 'eaten' by text fields; use for deselecting.
      # if @window.text_input then
      #   @window.text_input = nil
      # else
        @window.start_menu_mode
      # end
    when Gosu::KbReturn
      @window.text_input = nil
      begin
        server = TCPSocket.open(ARGV.first || Constants::HOSTNAME, Constants::PORT)
      rescue Errno::ECONNREFUSED => e
        # sleep 1
        retry
      end
      @window.server = server
      @window.start_game_mode(true)
    # when Gosu::MsLeft
    #   # Mouse click: Select text field based on mouse position.
    #   @window.text_input = @text_fields.find { |tf| tf.under_point?(@window.mouse_x, @window.mouse_y) }
    #   # Advanced: Move caret to clicked position
    #   @window.text_input.move_caret(@window.mouse_x) unless @window.text_input.nil?
    end
  end

end
