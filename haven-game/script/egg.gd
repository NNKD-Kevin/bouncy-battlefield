extends CharacterBody2D
var bounciness=1.0
var side=null
var type='egg'
func _physics_process(delta: float) -> void:
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if collider is CharacterBody2D:
			if collider.side!=side:
				collider.hp-=10
				collider.flash_animation.play('flash')
				queue_free()
			elif collider.side==side:
				collider.hp+=10
				collider.hp=min(collider.hp,collider.max_hp)
				queue_free()
	if not Global.combat:
		queue_free()
			
