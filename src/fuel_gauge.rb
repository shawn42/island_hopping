class FuelGaugeView < GraphicalActorView
  def setup
    @color = [255,12,12]
    @height = 400
    @width = 30
  end

  def draw(target,x_off,y_off)
    x = @actor.x
    y = @actor.y - 20
    fuel = @actor.fuel
    max_fuel = @actor.max_fuel

    target.draw_box_s [x,y],[x+@width,y-(fuel.to_f/max_fuel*@height)], @color
  end
end

class FuelGauge < Actor
  attr_accessor :max_fuel
  def setup
    @copter = opts[:helicopter]
    @max_fuel = @copter.fuel
  end

  def fuel
    @copter.fuel
  end
end
