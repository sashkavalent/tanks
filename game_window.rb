require_relative 'setup_window'
require_relative 'remote_event'

class GameWindow < Gosu::Window
  include SetupWindow
  include RemoteEvent
  TICK = 1.0/60.0

  attr_accessor :bullets
  attr_reader :borders, :space, :server_state, :shot
  def initialize(server, client)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @server, @client = server, client
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @score = 0
    @space = CP::Space.new
    @space.damping = 0.2
    @tanks = []
    @bullets = []
    @server_state = { events: []}
    @client_state = {}
    @bang = Gosu::Sample.new(self, "media/bang.wav")
    @shot = Gosu::Sample.new(self, "media/shot.wav")
    @miss = Gosu::Sample.new(self, "media/miss.wav")
    @battle_city = Gosu::Sample.new(self, "media/battle_city.wav")
    @battle_city.play
    # @racing = Gosu::Song.new(self, "media/racing.wav")
    # @racing.play(true) if server?

    setup_background
    setup_tanks
    setup_collisions if server?
    set_caption
  end

  def client?
    !!@server
  end

  def server?
    !!@client
  end

  private

  def update
    @space.step(Constants::TICK)
    if server?
      @server_state['s_tank'] = @s_tank.serialize
      @server_state['c_tank'] = @c_tank.serialize
      @server_state['bots'] = bots.map(&:serialize)
      @client.puts(@server_state.to_json)
      @server_state = { 'events' => []}

      @client_state = JSON.parse(@client.gets)
      bots_move
      players_move
    elsif client?
      @server.puts @client_state.to_json
      @client_state = {}
      @server_state = JSON.parse(@server.gets)
      @server_state['events'].each { |event| perform_remote_event(event) }
      @c_tank.deserialize(@server_state['c_tank'])
      @s_tank.deserialize(@server_state['s_tank'])
      @server_state['bots'].each.with_index { |bot_state, i| bots[i].deserialize(bot_state) }
      players_move
    end
    bullets_move
  end

  def players_move
    if server?
      case go = true
      when button_down?(Gosu::KbUp)
        @s_tank.position = Position::TOP
      when button_down?(Gosu::KbDown)
        @s_tank.position = Position::BOTTOM
      when button_down?(Gosu::KbLeft)
        @s_tank.position = Position::LEFT
      when button_down?(Gosu::KbRight)
        @s_tank.position = Position::RIGHT
      else
        go = false
      end
      @s_tank.reset_forces
      @s_tank.move if go

      go = true
      case @client_state['key']
      when 'up' then @c_tank.position = Position::TOP
      when 'down' then @c_tank.position = Position::BOTTOM
      when 'left' then @c_tank.position = Position::LEFT
      when 'right' then @c_tank.position = Position::RIGHT
      else
        go = false
      end
      @c_tank.fire if @client_state['fire'] == true
      @c_tank.reset_forces
      @c_tank.move if go

    elsif client?
      key = case (go = true)
      when button_down?(Gosu::KbUp) then 'up'
      when button_down?(Gosu::KbDown) then 'down'
      when button_down?(Gosu::KbLeft) then 'left'
      when button_down?(Gosu::KbRight) then 'right'
      else
        go = false
        nil
      end
      @client_state['key'] = key if go
    end
  end

  def bots_move
    bots.each do |bot|
      bot.reset_forces
      bot.move
    end
  end

  def bullets_move
    # @tanks.each { |tank| tank.bullets.each(&:move) }
    @bullets.each(&:move)
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @tanks.each(&:draw)
    @bullets.each(&:draw)
    # @tanks.each { |tank| tank.bullets.each(&:draw) }
    @font.draw("Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then close end
    if id == Gosu::KbSpace
      if server?
        @s_tank.fire
      elsif client?
        @client_state['fire'] = true
      end
    end
    if id == Gosu::KbLeftControl then binding.pry end
  end

  def bots
    @tanks.select { |tank| tank.is_a? TankBot }
  end
end
