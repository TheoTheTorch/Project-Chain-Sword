extends Node2D


onready var swing_dmg : int = get_node("/root/PlayerStats").swing_damage
onready var tip_dmg : int = get_node("/root/PlayerStats").tip_damage

onready var ActualLine2D = $Chain/ActualLine2D
onready var Sword = $SwordArea
onready var SwordTip = $SwordTip


func _ready() -> void:
	$SwordArea.damage = swing_dmg
	$SwordTip.damage = tip_dmg

func _physics_process(_delta: float) -> void:
	update_sword(Array(ActualLine2D.points))

func update_sword(points: Array) -> void:
	if points != []:
		Sword.position = points[-1]
# warning-ignore:integer_division
		Sword.rotation = points[int(len(points)/2)].direction_to(points[-1]).angle()
		
		SwordTip.position = points[-1]
# warning-ignore:integer_division
		SwordTip.rotation = points[int(len(points)/2)].direction_to(points[-1]).angle()



