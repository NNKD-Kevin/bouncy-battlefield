extends CharacterBody2D
@export var bounciness:=1.0
const speed=50
var hp=300
var damage=10
var side=null
var type='turtle'
@onready var health_bar=$HealthBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_animation: AnimationPlayer = $AnimatedSprite2D/FlashAnimation
@onready var cooldown: Timer = $cooldown
@onready var stun: Timer = $stun
var moving=true
var ready_to_hit=true
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
func _process(delta: float) -> void:
	health_bar.value=hp
	
		 

func _physics_process(delta: float) -> void:
	var collision=move_and_collide(velocity*delta)
	if collision and moving:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if collider is CharacterBody2D:
			if collider.side!=side and ready_to_hit:
				collider.hp-=damage
				health_bar.value=hp
				animated_sprite_2d.play("attack")
				collider.flash_animation.play("flash")
				ready_to_hit=false
				cooldown.start()
	if hp<=0:
		queue_free()

	


func _on_cooldown_timeout() -> void:
	ready_to_hit=true


func _on_stun_timeout() -> void:
	moving=true
