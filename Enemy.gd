extends KinematicBody2D

var velocity = 0
const MOVE_SPEED = 100
const GRAVITY = 50
const JUMP_FORCE = 1000
const MAX_FALL_SPEED = 1000
var y_velo = 0

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().root.get_node("Main/Player")
	
func _physics_process(_delta):
	var relativePos = player.position - position
	if relativePos.x < 100:
		$Sprite.flip_h = true
		velocity = -1
	elif relativePos.x > -100:
		$Sprite.flip_h = false
		velocity = 1
	else:
		velocity = 0
	
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(velocity * MOVE_SPEED, y_velo))
	y_velo += GRAVITY
	animate()
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func animate():
	$AnimationPlayer.play("idle")
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
