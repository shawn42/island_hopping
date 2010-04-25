require 'physical_stage'
class DemoStage < PhysicalStage
  def setup
    super
    @svg_doc = resource_manager.load_svg @opts[:file]
    dynamic_actors = create_actors_from_svg @svg_doc

    @helicopter = dynamic_actors[:helicopter]
    @helicopter.ocean = spawn(:ocean)

    @score = spawn :score, :x=> 30, :y => 30
    @stage_start_score = backstage[:score]

    @helicopter.when :remove_me do
      if @helicopter.crashed? || @helicopter.drown?
        backstage[:score] = @stage_start_score
        fire :restart_stage
      end
    end

    spawn :fuel_gauge, :x=>20, :y=>500, :helicopter => @helicopter

    setup_collisions
    space.gravity = vec2(0,200)
  end

  def setup_collisions
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

    space.add_collision_func(:helicopter, :lava_rock) do |heli, rock|
      rock_obj = director.find_physical_obj rock
      if rock_obj.alive?
        heli_obj = director.find_physical_obj heli
        rock_obj.remove_self
        heli_obj.crash_and_burn
      end
    end

    space.add_collision_func(:lava_rock, :gas) do |rock, gas|
      gas_obj = director.find_physical_obj gas
      if gas_obj.alive?
        gas_obj.remove_self
        # TODO boom!
      end
    end

    space.add_collision_func(:helicopter, :safe_zone) do |heli, safe_zone|
      puts "YOU WIN"
      fire :next_stage 
    end



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

