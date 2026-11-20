extends Node2D
const ANIMAL=preload("res://scenes/animal.tscn")

@onready var center_container: CenterContainer = $CanvasLayer/CenterContainer

@onready var maps: Node2D = $Maps
@onready var music: AudioStreamPlayer2D = $Sounds/Music
@onready var sandstorm: AudioStreamPlayer2D = $Sounds/Sandstorm
@onready var h_box_container: HBoxContainer = $CanvasLayer/Recruit/HBoxContainer
@onready var sandstorm_timer: Timer = $Timers/Sandstorm_Timer
@onready var sandstorm_effect: Panel = $CanvasLayer/Sandstorm_Effect
@onready var sandstorm_count: Label = $CanvasLayer/Sandstorm_Count
@onready var button: Button = $"CanvasLayer/Time speed/Button"
@onready var button_2: Button = $"CanvasLayer/Time speed/Button2"
@onready var button_3: Button = $"CanvasLayer/Time speed/Button3"
@onready var animal_panel: Panel = $Animal_Panel


var starting_nodes:int
var current_nodes:int
var x_min=0
var x_max=0
var y_min=0
var y_max=0
var spawn_count=0

func select_map(index: int) -> void:
	var children = maps.get_children()
	for i in children.size():
		var active = (i == index)
		if index==0:
			x_min=250
			x_max=900
			y_min=150
			y_max=500
		elif index==1:
			x_min=300
			x_max=875
			y_min=200
			y_max=350
		var m = children[i]
		m.visible = active
		m.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
		if m is TileMap:
			for layer in m.get_layers_count():
				m.set_layer_enabled(layer, active)
func _ready():
	button.visible = false
	button_2.visible = false
	button_3.visible = false
	Global.arrange.connect(_on_arrange)
	music.play()
	if center_container:
		center_container.visible = false
	sandstorm_effect.visible=false
func spawn_type(type:String,side:String):
	var node = ANIMAL.instantiate()
	node.type=type
	node.side=side
	var is_good=side=='good'
	var x_offset=(x_max-x_min)/2
	var spawn_x=x_min if side=='good' else x_min+x_offset
	if side=='bad':
		node.position = Vector2(randi_range(spawn_x, spawn_x+x_offset), randi_range(y_min, y_max))
	elif side=='good':
		node.position=Vector2(50,50*spawn_count)
	node.add_to_group("animals" if is_good else "enemies")
	add_child(node)
	spawn_count+=1
func _on_arrange():
	spawn_count=0
	select_map(randi()%maps.get_child_count())
	for enemy in Global.enemies:
		spawn_type(enemy,'bad')
	for animal in Global.animals:
		spawn_type(animal,'good')
func clear():
	if not is_inside_tree():
		return
	for a in get_tree().get_nodes_in_group("animals"):
		a.queue_free()
	for e in get_tree().get_nodes_in_group("enemies"):
		e.queue_free()
func _process(_delta: float) -> void:
	if Global.sandstorm_on:
		sandstorm_effect.visible=true
	else:
		sandstorm_effect.visible=false
		sandstorm.stop()
	if Global.ready_to_start:
		animal_panel.visible=true
	else:
		animal_panel.visible=false
	if not Global.combat:
		return
	sandstorm_count.text=str(int(sandstorm_timer.time_left))
	if sandstorm_timer.time_left<10:
		sandstorm_count.add_theme_color_override("font_color",Color.RED)
	else:
		sandstorm_count.add_theme_color_override("font_color",Color.WHITE)
	#Win/Lose Condition
	var animals_left = get_tree().get_nodes_in_group("animals").size()
	var enemies_left = get_tree().get_nodes_in_group("enemies").size()
	if animals_left == 0:
		Global.combat = false
		Global.sandstorm_on=false
		get_tree().change_scene_to_file("res://scenes/Defeat.tscn")
		clear()
		Engine.time_scale = 1.0
	elif enemies_left == 0:
		if Global.level==10:
			get_tree().change_scene_to_file("res://scenes/win.tscn")
		Global.combat = false
		Global.sandstorm_on=false
		Global.level += 1
		Global.enemies=[]
		print(Global.level)
		clear()
		Engine.time_scale = 1.0
		if Global.level<10:
			h_box_container.choose()
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and not Global.combat and Global.ready_to_start:
		Global.ready_to_start=false
		if center_container:
			center_container.visible=false
		button.visible = true
		button_2.visible = true
		button_3.visible = true
		Global.combat = true
		Global.sandstorm_on=false
		sandstorm_timer.start()
		


func _on_sandstorm_timer_timeout() -> void:
	Global.sandstorm_on=true
	sandstorm.play()

func _on_button_pressed() -> void:
	Engine.time_scale = 1.0

func _on_button_2_pressed() -> void:
	Engine.time_scale = 3.0

func _on_button_3_pressed() -> void:
	Engine.time_scale = 5.0
