extends CharacterBody2D
@export var bounciness:=1.0
const speed=100
var hp=100
var max_hp=100
var side=null
var type='pig'
@onready var health_bar=$HealthBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_animation: AnimationPlayer = $AnimatedSprite2D/FlashAnimation
@onready var cooldown: Timer = $cooldown
@onready var stun: Timer = $stun
var moving=true
var green_style := StyleBoxFlat.new()
var red_style := StyleBoxFlat.new()

var poo_path=preload("res://scenes/poo.tscn")

var ready_to_hit=true

var started=false
func _ready() -> void:
	green_style.bg_color = Color.GREEN
	red_style.bg_color = Color.RED
	if is_in_group("enemies"):
		side='bad'
		health_bar.add_theme_stylebox_override("fill",red_style)
	elif is_in_group("animals"):
		side='good'
		health_bar.add_theme_stylebox_override("fill",green_style)
	health_bar.value=hp
	velocity=Vector2.RIGHT.rotated(randf()*TAU)*speed
func _process(delta: float) -> void:
	health_bar.value=hp
		 

func _physics_process(delta: float) -> void:
	if hp<=0:
		queue_free()
	if not moving:
		return
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if not (collider is CharacterBody2D) and ready_to_hit:
			fire()
			ready_to_hit=false
			cooldown.start()

const POO_SPEED = 1

func fire():
	var targets = get_tree().get_nodes_in_group("enemies")
	if targets.is_empty():
		return
	var nearest = targets[0]
	for t in targets:
		if t.global_position.distance_squared_to(global_position) < nearest.global_position.distance_squared_to(global_position):
			nearest = t
	var dir = global_position.direction_to(nearest.global_position)

	var poo = poo_path.instantiate()
	poo.velocity = dir * POO_SPEED
	poo.side=side
	poo.add_collision_exception_with(self)
	add_collision_exception_with(poo)
	get_parent().add_child(poo)
	poo.global_position = global_position + dir * 40


func _on_cooldown_timeout() -> void:
	ready_to_hit=true


func _on_stun_timeout() -> void:
	moving=true
