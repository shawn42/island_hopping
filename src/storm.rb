class RainDropView < ActorView
  def setup
    @color = [155,155,180]
  end

  def draw(target, x_off, y_off)
    x = @actor.x + x_off
    y = @actor.y + y_off
    r = @actor.size
    target.draw_circle_s [x,y], r, @color
  end
end
class RainDrop < Actor
  has_behaviors :updatable, {:physical => {
      :shape => :circle,
      :mass => 3,
      :radius => 1,
      :friction => 1.7,
      :moment => 410 }}

  attr_accessor :size
  def setup
    super
    @size = 1
    x_dir = rand(4_000)-2_000
    move_vec = vec2(x_dir,8500)
    physical.body.apply_impulse(move_vec, ZERO_VEC_2) 
    @ttl = opts[:ttl]
    @ttl ||= 2000
    @lived_ms = 0
  end

  def update(time)
    super
    @lived_ms += time
    remove_self if @lived_ms > @ttl
  end
end
class Storm < Actor
  has_behaviors :graphical, :updatable, :audible

  def setup
    stage.add_timer "#{object_id}rain_maker", 200 do
      hw = image.size[0]*0.5
      rain_x = @x + rand(20) - 10 + hw
      spawn :rain_drop, :x => rain_x, :y => @y + hw
    end
  end
end
