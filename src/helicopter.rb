require 'actor'
require 'graphical_actor_view'

class Helicopter < Actor
  has_behaviors :updatable, :graphical, {:layered => {:layer => 2}}, {:physical => {
      :shape => :poly,
      :moment => Float::INFINITY,
      :mass => 150,
      :friction => 0.9,
      :verts => [[-20,-20],[-20,20],[40,20],[40,-20]]}}

  attr_accessor :fly_up, :fly_right, :fly_left, :fuel, :ocean

  def setup
    input_manager.while_key_pressed :up, self, :fly_up
    input_manager.while_key_pressed :left, self, :fly_left
    input_manager.while_key_pressed :right, self, :fly_right
    @people_count = 0
    input_manager.reg KeyDownEvent, :space do
      drop_off
    end
    @fuel = opts[:fuel]
    @fuel ||= 100000
  end

  def drown?
    @drown
  end

  def drown
    puts "YOU DROWN"
    @drown = true
    remove_self 
  end

  def fuel?
    @fuel > 0
  end

  def out_of_gas
    crash_and_burn
  end

  def crashed?
    @crashed
  end

  def crash_and_burn
    puts "YOU CRASH!"
    @crashed = true
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

  def adjust_view
    viewport = stage.viewport
    right_limit = 800 - viewport.x_offset 
    if x > right_limit
      viewport.scroll(right_limit-x,0)
    end
    left_limit = 200 - viewport.x_offset 
    if x < left_limit
      viewport.scroll(left_limit-x,0)
    end
  end

  def update(delta)
    adjust_view
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
    drown if @ocean && ((y+h-20) > (stage.viewport.height-@ocean.level))
  end

  def w; 40; end
  def h; 40; end
end
