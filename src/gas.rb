class Gas < Actor
  has_behaviors :updatable, :graphical, {:physical => {
      :shape => :poly,
      :moment => Float::INFINITY,
      :mass => 30,
      :friction => 0.9,
      :verts => [[-5,-5],[-5,5],[5,5],[5,-5]]}}
end
