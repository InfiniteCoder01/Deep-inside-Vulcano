extends Line2D

@onready var shader: ShaderMaterial = material
var curve: Curve2D

func _ready() -> void:
	curve = Curve2D.new()
	for point in points: curve.add_point(point)

var fill := 0.0

func _process(delta: float) -> void:
	fill += delta * 400.0
	for child in get_children():
		if !(child is Tap): continue
		if child.open: continue
		var offset = curve.get_closest_offset(child.position)
		fill = min(fill, offset)
	shader.set_shader_parameter("fill", fill / curve.get_baked_length())
