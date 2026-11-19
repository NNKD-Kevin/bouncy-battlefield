extends CharacterBody2D

@onready var health_bar=$HealthBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_animation: AnimationPlayer = $AnimatedSprite2D/FlashAnimation
@onready var devour_timer: Timer = $devour_timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var stun: Timer = $stun
var moving=true
@export var bounciness:=1.0
const speed=300
var hp=100
var max_hp=100
var side=null
var type='wolf'
var devour_ready=false
var started=false
var green_style := StyleBoxFlat.new()
var red_style := StyleBoxFlat.new()

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
	devour_timer.start()
func _process(delta: float) -> void:
	health_bar.value=hp
	if devour_ready:
		hp-=delta*5



func _physics_process(delta: float) -> void:
	var collision=move_and_collide(velocity*delta)
	if collision and moving:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if collider is CharacterBody2D:
			if collider.side!=side and devour_ready:
				collider.queue_free()
				devour_ready=false
				devour_timer.start()
				hp+=collider.hp
				hp=min(100,hp)
	if hp<=0:
		queue_free()
	if velocity.x<0:
		animated_sprite_2d.flip_h=true
	else:
		animated_sprite_2d.flip_h=false


func _on_devour_timer_timeout() -> void:
	devour_ready=true
	audio_stream_player_2d.play()


func _on_stun_timeout() -> void:
	moving=true
