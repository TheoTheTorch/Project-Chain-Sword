extends Line2D


export var segments : int = 10
export var interval : float = 0.02
export var color : Gradient = null

onready var Polygon : Polygon2D = $Polygon2D

var time : float = 0.0
var polygon : PoolVector2Array = PoolVector2Array()
var polygons : Array = Array()
var colors : PoolColorArray = PoolColorArray()

func _ready() -> void:		
	assert(points.size() == 2, "SwordLine needs exactly 2 points.")
	assert(segments >= 2, "SwordLine needs at least 2 segments.")
	assert(not is_zero_approx(interval), "Interval is too small.")
	assert(color, "SwordLine needs a color(-gradient).")
	self_modulate.a = 0.0
	Polygon.set_as_toplevel(true)
	
	for i in segments:
		polygon.append(to_global(points[0]))
# warning-ignore:return_value_discarded
		polygon.insert(0, to_global(points[1]))
		colors.append(color.interpolate(range_lerp(i, 0, segments, 1.0, 0.0)))
# warning-ignore:return_value_discarded
		colors.insert(0, colors[-1])
		
	
	for i in segments - 1:
		polygons.append(create_first_polygon(i, segments))
		polygons.append(create_second_polygon(i, segments))
	
	Polygon.polygon = polygon
	Polygon.polygons = polygons
	Polygon.vertex_colors = colors
#	print(Array(colors))


func _process(delta: float) -> void:
	time += delta
	if time > interval:
		time -= interval
		polygon.remove(segments - 1)
		polygon.remove(segments - 1)
		polygon.append(to_global(points[0]))
# warning-ignore:return_value_discarded
		polygon.insert(0, to_global(points[1]))
	polygon[0] = to_global(points[0])
	polygon[-1] = to_global(points[1])
	Polygon.polygon = polygon


func create_first_polygon(x : int, m : int) -> Array:
	var first : Array = Array()
	first.append(x)
	first.append(x + 1)
	first.append(2 * m - x - 1)
	return first
	
func create_second_polygon(x : int, m : int) -> Array:
	var second : Array = Array()
	second.append(x + 1)
	second.append(2 * m - x - 2)
	second.append(2 * m - x - 1)
	return second
