require 'physical_stage'
class DemoStage < PhysicalStage
  def setup
    super
    @score = spawn :score, :x=> 30, :y => 30

    spawn :cloud, :x=>150, :y=>40
    spawn :cloud, :x=>450, :y=>140

    @helicopter = spawn :helicopter, :x=>50, :y=>400, :ocean => spawn(:ocean)
    spawn :fuel_gauge, :x=>20, :y=>500, :helicopter => @helicopter

    space.add_collision_func(:helicopter, :person) do |heli, person|
      person_obj = director.find_physical_obj person
      if person_obj.alive?
        heli_obj = director.find_physical_obj heli
        heli_obj.pickup person_obj
        @score += 100
      end
    end

    space.add_collision_func(:helicopter, :gas) do |heli, gas|
      gas_obj = director.find_physical_obj gas
      if gas_obj.alive?
        gas_obj.remove_self
        heli_obj = director.find_physical_obj heli
        heli_obj.fuel += 1000
      end
    end


    spawn :gas, :x =>60, :y => 655
    island_at 50, 680
    island_at 90, 680
    island_at 130, 680

    spawn :person, :x =>260, :y => 655
    island_at 250, 680
    island_at 290, 680
    island_at 330, 680

    spawn :person, :x =>460, :y => 695
    island_at 450, 720
    island_at 490, 720
    island_at 530, 720

    space.gravity = vec2(0,200)
  end

  def island_at(x,y)
    @islands ||= []

    island = spawn :island, :x=>x, :y=>y

    @islands << island
  end

  def draw(target)
    target.fill [17,117,221]
    super
  end
end

