extends Node2D


export (float) var ropeLength = 75
export (float) var constrain = 2.88 	# distance between points
export (Vector2) var gravity = Vector2(0,0)
export (float) var dampening = 0.94
export (bool) var startPin = true
export (bool) var endPin = true
#export 

export var max_range : int = 125

onready var line2D: = $Line2D
onready var ActualLine2D = $ActualLine2D

var pos: PoolVector2Array
var posPrev: PoolVector2Array
var pointCount: int


func _ready()->void:
	pointCount = get_pointCount(ropeLength)
	resize_arrays()
	init_position()

func get_pointCount(distance: float)->int:
	return int(ceil(distance / constrain))

func resize_arrays():
	pos.resize(pointCount)
	posPrev.resize(pointCount)

func init_position()->void:
	for i in range(pointCount):
		pos[i] = position + Vector2(constrain *i, 0)
		posPrev[i] = position + Vector2(constrain *i, 0)
	position = Vector2.ZERO


func _process(delta)->void:
	move_rope()
	
	update_points(delta)
	update_constrain(delta)
	update_constrain(delta)
	update_constrain(delta)
#	update_constrain(delta)
#	update_constrain(delta)
#	update_constrain(delta)

	# Send positions to Line2D for drawing
	line2D.points = pos
	
	show_line()



func set_start(p:Vector2)->void:
	pos[0] = p
	posPrev[0] = p

func set_last(p:Vector2)->void:
	pos[pointCount-1] = p
	posPrev[pointCount-1] = p

func update_points(delta)->void:
	for i in range (pointCount):
		# not first and last || first if not pinned || last if not pinned
		if (i!=0 && i!=pointCount-1) || (i==0 && !startPin) || (i==pointCount-1 && !endPin):
			var velocity = (pos[i] -posPrev[i]) * dampening
			posPrev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain(delta)->void:
	for i in range(pointCount):
		if i == pointCount-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain * delta - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		
		# if first point
		if i == 0:
			if startPin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		# if last point, skip because no more points after it
		elif i == pointCount-1:
			pass
		# all the rest
		else:
			if i+1 == pointCount-1 && endPin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)



func show_line() -> void:
	var farthest := pos[0]
	# check for farthest distance
	for point in line2D.points:
		if point.distance_to(pos[0]) > farthest.distance_to(pos[0]): farthest = point
	
	ActualLine2D.clear_points()
	for i in range(Array(line2D.points).find(farthest)):
		ActualLine2D.add_point(line2D.points[i])
	

func move_rope() -> void:
	var posi := pos[0]
	var mous : Vector2
	mous = get_global_mouse_position()
	
	posi = camera_center() - mous.direction_to(camera_center()) * min(mous.distance_to(camera_center()), max_range)
	
	
	set_start(posi)
	set_last(posi)

func camera_center():
	var vtrans = get_canvas_transform()
	var top_left = -vtrans.get_origin() / vtrans.get_scale()
	var vsize = get_viewport_rect().size
	return top_left + 0.5*vsize/vtrans.get_scale()
