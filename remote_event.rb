module RemoteEvent
  def perform_remote_event(event_type, data)
    case event_type
    when 'fire'
      case data
      when 'c_tank' then @c_tank.fire
      when 's_tank' then @s_tank.fire
      end
    end
  end
end
