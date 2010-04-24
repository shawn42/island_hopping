require 'actor'
require 'graphical_actor_view'

class IslandView < GraphicalActorView
  def setup
    @color = [206,217,62]
    @other_color = [255,12,12,140]
  end
  def draw(target,x_off,y_off)
    super
    x = @actor.x
    y = @actor.y
    w,h = *@actor.image.size
    hw = (w * 0.5).floor
    hh = (h * 0.5).floor

    target.draw_box_s [x-hw,y+hh], [x+hw,3000], @color
#    bb = @actor.shape.bb
#    target.draw_box [bb.l,bb.b],[bb.r,bb.t], @other_color
  end
end

class Island < Actor
  has_behaviors :graphical, {:physical => {
      :shape => :poly,
      :moment => Float::INFINITY,
      :mass => Float::INFINITY,
      :fixed => true,
      :friction => 0.9,
      :verts => [[-20,-20],[-20,20],[20,20],[20,-20]]}}
end
