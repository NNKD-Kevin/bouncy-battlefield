extends CharacterBody2D
var bounciness=1.0
var side=null

func _physics_process(delta: float) -> void:
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())*bounciness
		var collider=collision.get_collider()
		if collider is CharacterBody2D:
			if collider.side!=side:
				collider.hp-=5
				collider.moving=false
				if collider.stun:
					collider.stun.wait_time=2
					collider.stun.start()
					collider.flash_animation.play('flash')
				queue_free()
	if not Global.combat:
		queue_free()
			
