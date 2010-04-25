require 'actor'
require 'graphical_actor_view'

class HelicopterView < GraphicalActorView
  def setup
    @color = [255,12,12,140]
  end

  def draw(target,x_off,y_off)
    super

#    bb = @actor.shape.bb
#    target.draw_box [bb.l,bb.b],[bb.r,bb.t], @color
  end
end

class Helicopter < Actor
  has_behaviors :updatable, :graphical, {:physical => {
      :shape => :poly,
      :moment => Float::INFINITY,
      :mass => 150,
      :friction => 0.9,
      :verts => [[-20,-20],[-20,20],[40,20],[40,-20]]}}

  attr_accessor :fly_up, :fly_right, :fly_left, :fuel

  def setup
    input_manager.while_key_pressed :up, self, :fly_up
    input_manager.while_key_pressed :left, self, :fly_left
    input_manager.while_key_pressed :right, self, :fly_right
    @people_count = 0
    input_manager.reg KeyDownEvent, :space do
      drop_off
    end
    @fuel = opts[:fuel]
    @fuel ||= 1000000
    @ocean = opts[:ocean]
  end

  def drown
    puts "YOU DROWN"
    remove_self 
  end

  def fuel?
    @fuel > 0
  end

  def out_of_gas
    crash_and_burn
  end

  def crash_and_burn
    puts "YOU CRASH!"
    remove_self 
  end

  def pickup(obj)
    @people_count ||= 0
    @people_count += 1
    obj.remove_self
  end

  def drop_off
    @people_count.times do
      spawn :person, :x => self.x - 40, :y => self.y
    end
    @people_count = 0
  end

  def update(delta)
    if fuel?
      speed = delta 
      if fly_up
        @fuel -= speed
        move_vec = vec2(0,-100) * speed
        physical.body.apply_impulse(move_vec, ZERO_VEC_2) 
      end
      if fly_right
        @fuel -= speed
        move_vec = vec2(100,0) * speed
        physical.body.apply_impulse(move_vec, ZERO_VEC_2) 
      end
      if fly_left
        @fuel -= speed
        move_vec = vec2(-100,0) * speed
        physical.body.apply_impulse(move_vec, ZERO_VEC_2) 
      end
    else
      out_of_gas
    end
    drown if (y+h-20) > (stage.viewport.height-@ocean.level)
  end

  def w; 40; end
  def h; 40; end
end
