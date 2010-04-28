require 'physical_stage'
class DemoStage < PhysicalStage
  def setup
    super
    setup_pause
    @svg_doc = resource_manager.load_svg @opts[:file]
    dynamic_actors = create_actors_from_svg @svg_doc

    @helicopter = dynamic_actors[:helicopter]
    @helicopter.ocean = spawn(:ocean)

    @score = spawn :score, :x=> 30, :y => 30
    @stage_start_score = backstage[:score]

    @helicopter.when :remove_me do
      if @helicopter.crashed? || @helicopter.drown?
        backstage[:score] = @stage_start_score
        spawn :label, :text => "YOU DIED", :size => 40, :x => 400, :y => 300
        add_timer :restart, 2000 do
          fire :restart_stage
        end
      end
    end

    spawn :fuel_gauge, :x=>20, :y=>500, :helicopter => @helicopter

    setup_collisions
    space.gravity = vec2(0,200)

    sound_manager.play_music :background
  end

  def setup_pause
    input_manager.reg KeyPressed, :p do
      pause
    end

    on_unpause do
      sound_manager.play_sound :pause
      sound_manager.play_sound :helicopter, :repeats => -1
      @pause.remove_self
    end

    on_pause do
      sound_manager.play_sound :pause
      sound_manager.stop_sound :helicopter

      @pause = spawn :label, :text => "pause", :x => 280, :y => 300, :size => 20
      input_manager.reg KeyPressed, :p do
        unpause
      end
    end
  end

  def setup_collisions
    space.add_collision_func(:helicopter, :person) do |heli, person|
      person_obj = director.find_physical_obj person
      if person_obj.alive?
        heli_obj = director.find_physical_obj heli
        heli_obj.pickup person_obj
        sound_manager.play_sound :pickup
        @score += 100
      end
    end

    space.add_collision_func(:helicopter, :gas) do |heli, gas|
      gas_obj = director.find_physical_obj gas
      if gas_obj.alive?
        gas_obj.remove_self
        heli_obj = director.find_physical_obj heli
        heli_obj.fuel += 1000
        sound_manager.play_sound :fuel
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
        sound_manager.play_music :explosion
      end
    end

    space.add_collision_func(:helicopter, :safe_zone) do |heli, safe_zone|
      unless @safe
        @safe = true
        puts "YOU ARE SAFE"
        people_count = @helicopter.people_count
        @people_count_label ||= spawn :label, :text => "YOU SAVED #{people_count}", :size => 40, :x => 300, :y => 300
        sound_manager.play_sound :safe

        add_timer :restart, 1000 do
          fire :next_stage 
        end
      end
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

