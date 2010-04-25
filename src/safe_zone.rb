require 'actor'

class SafeZone < Actor
  
  has_behaviors :graphical, {:physical => {
      :shape => :poly,
      :moment => Float::INFINITY,
      :mass => Float::INFINITY,
      :fixed => true,
      :friction => 0.9,
      :verts => [[-20,-20],[-20,20],[20,20],[20,-20]]}}
end
