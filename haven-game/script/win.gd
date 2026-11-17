extends Node2D
@onready var darken: AnimationPlayer = $Background/ColorRect/darken
@onready var raid: Label = $raid
@onready var raid_a: AnimationPlayer = $raid/raid
@onready var horde: Label = $horde
@onready var horde_a: AnimationPlayer = $horde/horde
@onready var win: Label = $Replay/win
@onready var win_a: AnimationPlayer = $Replay/win/win
@onready var replay_b: Button = $Replay/replay
@onready var timer_d: Timer = $Background/ColorRect/timer_d
@onready var timer_r: Timer = $raid/timer_r
@onready var timer_h: Timer = $horde/timer_h
@onready var timer_w: Timer = $Replay/timer_w
@onready var chick: AnimatedSprite2D = $Replay/animal/Animal/chick
@onready var chicken: AnimatedSprite2D = $Replay/animal/Animal/chicken
@onready var wolf: AnimatedSprite2D = $Replay/animal/Animal/wolf
@onready var crab: AnimatedSprite2D = $Replay/animal/Animal/crab
@onready var turtle: AnimatedSprite2D = $Replay/animal/Animal/turtle

func _ready() -> void:
	raid.visible = false
	horde.visible = false
	win.visible = false
	replay_b.visible = false
	chick.visible = false
	chicken.visible = false
	turtle.visible = false
	crab.visible = false
	wolf.visible = false
	raid.add_theme_color_override("font_color",Color.BLACK)
	horde.add_theme_color_override("font_color",Color.BLACK)
	win.add_theme_color_override("font_color",Color.BLACK)
	darken.play("darken")
	timer_d.start()
	

func _on_timer_d_timeout() -> void:
	raid.visible = true
	raid_a.play("raid")
	timer_r.start()

func _on_timer_r_timeout() -> void:
	horde.visible = true
	horde_a.play("horde")
	timer_h.start()

func _on_timer_h_timeout() -> void:
	win.visible = true
	win_a.play("win")
	timer_w.start()
	
func _on_timer_w_timeout() -> void:
	replay_b.visible = true
	chick.visible = true
	chicken.visible = true
	turtle.visible = true
	crab.visible = true
	wolf.visible = true

func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
