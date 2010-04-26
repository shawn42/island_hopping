require 'actor'

class Volcano < Actor
  has_behaviors :graphical, :updatable, :audible

  def setup
    stage.add_timer 'asplode#{self.object_id}', 1000 do 
      blow_top
    end
  end

  def blow_top
    w,h = *image.size
    hw = w*0.5
    play_sound :lava
    spawn :lava_rock, :x => @x + hw, :y => @y
  end
end

class LavaRock < Actor
  has_behaviors :updatable, :graphical, {:physical => {
      :shape => :circle,
      :mass => 30,
      :radius => 15,
      :friction => 1.7,
      :moment => 410 }}

  def setup
    super
    x_dir = rand(10_000)-5_000
    move_vec = vec2(x_dir,-11500)
    physical.body.apply_impulse(move_vec, ZERO_VEC_2) 
    @ttl = opts[:ttl]
    @ttl ||= 3000
    @lived_ms = 0
  end

  def update(time)
    super
    @lived_ms += time
    remove_self if @lived_ms > @ttl

  end
end
