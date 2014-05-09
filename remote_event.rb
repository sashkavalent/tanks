module RemoteEvent
  def perform_remote_event(event)
    data = event['data']
    case event['event_type']
    when 'fire'
      fire_event(data)
    when 'destroy'
      destroy_event(data)
    end
  end

  def destroy_event(data)
    case data['figure_type']
    when 'bullet'
      tank = @tanks[data['tank_id']]
      tank.bullets.delete_at(data['bullet_id'])
    when 'tank'
      @tanks.delete_at(data['tank_id'])
    end
  end

  def fire_event(data)
    @tanks[data['tank_id']].fire
  end
end
