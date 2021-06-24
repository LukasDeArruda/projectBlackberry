extends KinematicBody2D

export var moveSpeed = 500
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000

var facingRight = true
var isDash = false
var isAttack = false
var movement = Vector2()

onready var sprite = $AnimatedSprite

#crazy errors happen only when you die while dashing
#might not be as big of an issue with this setup

func _input(event):
	if event.is_action_pressed("dash"):
		if movement.x == 0:
			movement.x += moveSpeed
		dash()
	
func get_input():
	if Input.is_action_pressed("ui_right"):
		movement.x += moveSpeed
		$IdleHitbox.disabled = true
		$RunHitbox.disabled = false
	if Input.is_action_pressed("ui_left"):
		movement.x -= moveSpeed
		$IdleHitbox.disabled = true
		$RunHitbox.disabled = false
	if Input.is_action_pressed("attack"):
		isAttack = true
		$IdleHitbox.disabled = true
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if movement.x == 0:
		$IdleHitbox.disabled = false
		$RunHitbox.disabled = true

func _physics_process(_delta):
	movement.x = 0
	get_input()

# warning-ignore:return_value_discarded
	move_and_slide(movement, Vector2(0, -1))
	
	var grounded = is_on_floor()
	movement.y += GRAVITY
	if grounded and Input.is_action_pressed("jump"):
		movement.y = -JUMP_FORCE
		
	if grounded and movement.y >= 5:
		movement.y = 5
	if movement.y > MAX_FALL_SPEED:
		movement.y = MAX_FALL_SPEED
	if position.y > 1200:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	
	if facingRight and movement.x < 0:
		flip()
	if !facingRight and movement.x > 0:
		flip()
	animates_player(movement.x)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Enemy":
# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()

# When you get to the point where you're gonna make an attack,
# make the hitbox of the attack an Area2D, see if that'll work


func flip():
	facingRight = !facingRight
	sprite.flip_h = !sprite.flip_h

func animates_player(direction):
	if direction != 0  and is_on_floor():
		sprite.play("run")
	elif !is_on_floor():
		sprite.play("jump")
	elif isAttack:
		sprite.play("StandAttack")
		isAttack = false
	else:
		sprite.play("idle")

func dash():
	isDash = true
	moveSpeed *= 2
# warning-ignore:return_value_discarded
	yield(get_tree().create_timer(0.5), "timeout")
	moveSpeed = 500
	isDash = false
