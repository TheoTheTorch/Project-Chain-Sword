extends Node2D


onready var ActualLine2D = $Chain/ActualLine2D
var chain_points = []

onready var Collision = $RopeArea/CollisionPolygon2D
onready var Hammer = $HammerArea


func _physics_process(_delta: float) -> void:
	update_collision_shape(Array(ActualLine2D.points))
	
	if Array(ActualLine2D.points) != []:
		Hammer.position = Array(ActualLine2D.points)[-1]

func update_collision_shape(points: Array) -> void:
	if points != []:
# warning-ignore:integer_division
		Collision.polygon = PoolVector2Array([points[0], points[int(len(points)/2)], points[-1]])


#	Collision.polygon = []
#	var lowest := Vector2.INF
#	var highest := -Vector2.INF
#
#	for point in points:
#		if point.y < lowest.y: lowest.y = point.y
#		if point.y > highest.y: highest.y = point.y
#		if point.x < lowest.x: lowest.x = point.x
#		if point.x > highest.x: highest.x = point.x
#
#	var poly : PoolVector2Array = [lowest, Vector2(lowest.x, highest.y), highest, Vector2(highest.x, lowest.y)]
#	Collision.polygon = poly
