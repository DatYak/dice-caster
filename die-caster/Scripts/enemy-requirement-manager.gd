class_name EnemyRequirementSelector
extends Node2D

@export var requirement_pool:Array

var active_req:EnemyReq

func _ready() -> void:
	if not requirement_pool.size() == 0:
		spawnRequirement()
	SignalBus.on_roll_presented.connect(on_result_presented)

func spawnRequirement():
	if not active_req == null:
		active_req.queue_free()
	var req_packed = requirement_pool.pick_random()
	var req = req_packed.instantiate()
	add_child(req)
	active_req = req

func on_result_presented(value:int, damage:int):
	if active_req._check_value(value):
		SignalBus.on_roll_succeeded.emit(damage)
		print("Success!")
	else:
		SignalBus.on_roll_failed.emit(active_req.getDamage())
		print("Failure!")
	
	# Reset with a new requirement
	spawnRequirement()
