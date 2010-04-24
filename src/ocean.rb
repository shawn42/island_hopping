require 'actor'
require 'actor_view'

class OceanView < ActorView
  def draw(target,x_off,y_off)
    level = @actor.level
    w,h = *target.screen.size

    target.draw_box_s([0,h], [w,h-level], [0,0,130, 150])
  end
end

class Ocean < Actor
  has_behavior :updatable, :layered => {:layer => 10}
  # level from bottom of screen in pixels
  attr_accessor :level

  def setup
    @level = 100
    @count = 0
  end

  def update(time)
    @count += time
    @level += Math.sin(@count) * time/100
  end
end
