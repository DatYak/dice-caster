class_name DieEditor

extends Node2D

@export var faces = 6
@export var face_sprite_width = 32
@export var face_sprite_gap = 3

@export var slot_radius = 100

@export var face_parent : Node2D
@export var dice_slot_packed: PackedScene
@export var die_face_packed : PackedScene

@export var base_damage = 10

@export var roll_duration_timer: Timer
@export var shake_speed = 0.05
@export var shake_speed_variance = 0.005
@export var max_shake_angle = 15.0
@export var face_tick_speed = 0.2
@export var face_tick_mult = 1.2

var shake_tween:Tween
var image_scale

@export var max_rolls = 5
var current_roll:RollData
var valid_slots: Array
var hits_left: Dictionary

var is_player_turn = true
var shaking = false

var face_slots : Array
var image : Sprite2D

func _ready() -> void:
	image = get_node("Image")
	image_scale = image.scale
	SignalBus.on_turn_resolved.connect(on_turn_resolved)
	current_roll = RollData.new()
	setupSlots()

func  _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE and is_player_turn:
			is_player_turn = false
			rollDie()

func setupSlots():
	var angle_increment = deg_to_rad(360.0 / faces)
	var angle = 0
	for i in range(faces):
		var slot = dice_slot_packed.instantiate()
		face_parent.add_child(slot)
		var slot_pos = Vector2(sin(angle) * slot_radius, cos(angle) * slot_radius)
		slot.position = slot_pos
		angle += angle_increment
		face_slots.append(slot)
		addDefaultFace(slot, i)

func addDefaultFace(slot, i):
		var face = die_face_packed.instantiate()
		var face_data = FaceData.new(i + 1, str(i + 1), FaceData.Quirk.None)
		face.setFaceData(face_data)
		slot.setFaceInSlot(face)

func rollDie():
	current_roll.reset(base_damage)
	
	valid_slots.clear()
	valid_slots = face_slots.duplicate()
	
	hits_left.clear()
	for i in range(valid_slots.size()):
		var hits_to_lock = valid_slots[i].getFaceData().hits_to_lock
		if hits_to_lock == 0:
			hits_to_lock = max_rolls
		hits_left.set(valid_slots[i], hits_to_lock)
	
	roll_duration_timer.start()
	startShakingDie()

func startShakingDie():
	shaking = true
	shakeDie()
	var scale_tween = image.get_tree().create_tween()
	scale_tween.tween_property(image, "scale", image_scale * face_tick_mult, face_tick_speed / 2)

func shakeDie():
	if not shaking:
		return
	var angle = randf_range(-max_shake_angle, max_shake_angle)
	var duration = shake_speed + randf_range(-shake_speed_variance, shake_speed_variance)
	
	shake_tween = image.get_tree().create_tween()
	shake_tween.tween_property(image, "rotation_degrees", angle, duration)
	shake_tween.tween_callback(shakeDie)

func stopShakingDie():
	shake_tween.kill()
	var tween = image.get_tree().create_tween()
	tween.tween_property(image, "rotation_degrees", 0,  face_tick_speed / 2)
	tween.tween_property(image, "scale", image_scale, face_tick_speed / 2)
	
	shaking = false

func on_roll_finish():
	var roll_again = rollSingleDie()
	if roll_again && current_roll.faces_rolled.size() <= max_rolls:
		roll_duration_timer.start()
	else:
		stopShakingDie()
		SignalBus.on_roll_presented.emit(current_roll)

func rollSingleDie() -> bool:
	# What if every slot is locked?
	if valid_slots.size() == 0:
		return false
	
	var slot = valid_slots.pick_random() as FaceSlot
	var result = slot.getFaceData()
	processQuirk(result)
	current_roll.addFaceToRoll(result)
	$Label.text = str(current_roll.presented_value)
	
	slot.startFacePulse(face_tick_speed,face_tick_mult)
	
	hits_left[slot] -= 1
	if hits_left[slot] <= 0:
		print("Locking " + str(slot.getFaceData().numerical_value))
		valid_slots.erase(slot)
	
	return result.will_roll_again

func on_turn_resolved(is_challenge_over:bool):
	is_player_turn = true
	if is_challenge_over:
		$Label.text = "?"

func processQuirk(data: FaceData ):
	match data.Quirk:
		FaceData.Quirk.None:
			pass
