module RemoteEvent
  def perform_remote_event(event_type, data)
    case event_type
    when 'fire'
      case data
      when 'player' then @friend.fire
      when 'friend' then @player.fire
      end
    end
  end
end
