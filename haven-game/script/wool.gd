extends CharacterBody2D
var bounciness=1.0
var side=null
var type='wool'
var center=null
var angle=0
var speed=0.02
var orbit_radius=Vector2(50,0)
func _physics_process(delta: float) -> void:
	angle+=speed
	if center:
		position=center.position+orbit_radius.rotated(angle)
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if collider is CharacterBody2D:
			if collider is Animal and collider.side!=side:
				collider.hp-=15
				collider.flash_animation.play('flash')
				queue_free()
			else:
				queue_free()
	if not Global.combat:
		queue_free()
			
