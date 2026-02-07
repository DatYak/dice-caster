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

@export var max_rolls = 5
var rolls_made = 0
var current_result = 0
var valid_slots: Array
var hits_left: Dictionary

var face_slots : Array
var image : Sprite2D

func _ready() -> void:
	image = get_node("Image")
	setupSlots()

func  _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			rollDie()

func setupSlots():
	var angle_increment = deg_to_rad(360 / faces)
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
	rolls_made = 0
	current_result = 0
	
	valid_slots.clear()
	valid_slots = face_slots.duplicate()
	
	hits_left.clear()
	for i in range(valid_slots.size()):
		var hits_to_lock = valid_slots[i].getFaceData().hits_to_lock
		if hits_to_lock == 0:
			hits_to_lock = max_rolls
		hits_left.set(valid_slots[i], hits_to_lock)
	
	
	while rolls_made <= max_rolls:
		rolls_made += 1
		var roll_again = rollSingleDie()
		print ("Rolling (Total: " + str(current_result) + ") ")
		if (not roll_again):
			break
	
	SignalBus.on_roll_presented.emit(current_result, base_damage)

func rollSingleDie() -> bool:
	var slot = valid_slots.pick_random() as FaceSlot
	var result = slot.getFaceData()
	processQuirk(result)
	current_result += result.numerical_value
	$Label.text = str(current_result)
	
	hits_left[slot] -= 1
	if hits_left[slot] <= 0:
		print("Locking " + str(slot.getFaceData().numerical_value))
		valid_slots.erase(slot)
	
	return result.will_roll_again

func processQuirk(data: FaceData ):
	match FaceData.Quirk:
		FaceData.Quirk.None:
			pass
