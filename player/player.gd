extends KinematicBody2D

export var ACCELERATION = 3000
export var MAX_SPEED = 18000
export var LIMIT_SPEED_Y = 1200
export var JUMP_HEIGHT = 36000
export var MIN_JUMP_HEIGHT = 12000
export var MAX_COYOTE_TIME = 6
export var JUMP_BUFFER_TIME = 10
export var WALL_JUMP_AMOUNT = 18000
export var WALL_JUMP_TIME = 10
export var WALL_SLIDE_FACTOR = 0.8
export var WALL_HORIZONTAL_TIME = 30
export var GRAVITY = 2100
export var DASH_SPEED = 36000


var velocity = Vector2()
var dash_velocity = Vector2()
var axis = Vector2()

var coyoteTimer = 0
var jumpBufferTimer = 0
var wallJumpTimer = 0
var wallHorizontalTimer = 0
var dashTime = 0

var spriteColor = "red"
var canJump = false
var friction = false
var wall_sliding = false
var trail = false
var isDashing = false
var hasDashed = false
var isGrabbing = false

var just_landed = false;


func _physics_process(delta):
	if !isDashing:
		dash_velocity = Vector2.ZERO;
	
	if velocity.y <= LIMIT_SPEED_Y:
		if !isDashing and not is_on_floor():
			velocity.y += GRAVITY * delta
	
	if is_on_floor():
		velocity.y = 0.1;

	friction = false
	
	getInputAxis()
	
	dash(delta)
	
	#wallSlide(delta)

	#basic vertical movement mechanics
	if wallJumpTimer > WALL_JUMP_TIME:
		wallJumpTimer = WALL_JUMP_AMOUNT
		if !isDashing && !isGrabbing:
			horizontalMovement(delta)
	else:
		wallJumpTimer += 1
	
	if !canJump:
		if !wall_sliding:
			if velocity.y >= 0:
				$AnimationPlayer.play(str(spriteColor, "Fall"))
			elif velocity.y < 0:
				$AnimationPlayer.play(str(spriteColor, "Jump"))

	#jumping mechanics and coyote time
	if is_on_floor():
		pass
		#if velocity.x > 0.5 or velocity.x < -0.5:
			#$Smoke.emitting = true;
			#$Smoke.locked_position = global_position;
			#$Smoke.locked_position.y += 20;
		
		if just_landed:
			$Landing.emitting = true;
			$Landing.locked_position = global_position;
			$Landing.locked_position.y += 20;
			just_landed = false;
		canJump = true
		coyoteTimer = 0
	else:
		just_landed = true;
		$Smoke.emitting = false;
		coyoteTimer += 1
		if coyoteTimer > MAX_COYOTE_TIME:
			canJump = false
			coyoteTimer = 0
		friction = true
	
	jumpBuffer(delta)

	if Input.is_action_just_pressed("jump"):
		just_landed = true;
		#$AnimationPlayer2.play("squash")
		if canJump:
			jump(delta)
			frictionOnAir()
		else:
			if $Rotatable/RayCast2D.is_colliding():
				wallJump(delta)
			frictionOnAir()
			jumpBufferTimer = JUMP_BUFFER_TIME #amount of frame

	setJumpHeight(delta)
	jumpBuffer(delta)

	move_and_slide(velocity + dash_velocity, Vector2.UP)

func jump(delta):
	velocity.y = -JUMP_HEIGHT * delta

func wallJump(delta):
	wallJumpTimer = 0
	velocity.x = -WALL_JUMP_AMOUNT * $Rotatable.scale.x * delta
	velocity.y = -JUMP_HEIGHT * delta
	$Rotatable.scale.x = -$Rotatable.scale.x

func wallSlide(delta):
	if !canJump:
		if $Rotatable/RayCast2D.is_colliding():
			wall_sliding = true
			if Input.is_action_pressed("grab"):
				isGrabbing = true
				if axis.y != 0:
					velocity.y = axis.y * 12000 * delta
					$AnimationPlayer.play(str(spriteColor, "Climb"))
				else:
					velocity.y = 0
					$AnimationPlayer.play(str(spriteColor, "Wall Slide"))
			else:
				isGrabbing = false
				velocity.y = velocity.y * WALL_SLIDE_FACTOR
				$AnimationPlayer.play(str(spriteColor, "Wall Slide"))
		else:
			wall_sliding = false
			isGrabbing = false
	

func frictionOnAir():
	if friction:
		velocity.x = lerp(velocity.x, 0, 0.01)

func jumpBuffer(delta):
	if jumpBufferTimer > 0:
		if is_on_floor():
			jump(delta)
		jumpBufferTimer -= 1

func setJumpHeight(delta):
	if Input.is_action_just_released("ui_up"):
		pass#if velocity.y < -MIN_JUMP_HEIGHT * delta:
		#	velocity.y = -MIN_JUMP_HEIGHT * delta

func horizontalMovement(delta):
	if Input.is_action_pressed("ui_right"):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				$AnimationPlayer.play(str(spriteColor, "Run"))
		else:
			velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				$AnimationPlayer.play(str(spriteColor, "Run"))

	elif Input.is_action_pressed("ui_left"):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				$AnimationPlayer.play(str(spriteColor, "Run"))
		else:
			velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				$AnimationPlayer.play(str(spriteColor, "Run"))
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
		if canJump:
			$AnimationPlayer.play(str(spriteColor, "Idle"))


func dash(delta):
	if !is_on_floor():
		if !hasDashed:
			if Input.is_action_just_pressed("dash"):
				# Get the horizontal and vertical axis values of the first joystick
				var axis_v = Vector2(
					Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
					Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
				)
				
				dash_velocity = axis_v * DASH_SPEED * delta 
				velocity.y = -1;
				spriteColor = "blue"
				#Input.start_joy_vibration(0, 1, 1, 0.2)
				isDashing = true
				hasDashed = true
				$Camera/ShakeCamera2D.shake(0.6*axis_v.x, 0.6*axis_v.y)

	if isDashing:
		trail = true
		dashTime += 1
		if dashTime >= int(0.25 * 1 / delta):
			isDashing = false
			trail = false
			dashTime = 0
		if is_on_floor():
			velocity.y = -DASH_SPEED*0.025;
			dash_velocity.y = 0;
			dash_velocity.x = dash_velocity.x*2

	if is_on_floor() && velocity.y && dashTime == 0:
		hasDashed = false
		spriteColor = "red"

func getInputAxis():
	var new_x_axis = 0
	new_x_axis = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var upwards = 0;
	if int(Input.is_action_pressed("jump")) or int(Input.is_action_pressed("ui_up")):
		upwards = 1;
	axis.y = int(Input.is_action_pressed("ui_down")) - upwards;
	if new_x_axis != 0:
		axis.x = new_x_axis
	if axis.y != 0 && new_x_axis != 0:
		axis.x = 0;
	axis = axis.normalized()



func _on_trailTimer_timeout():
	if trail:
		var trail_sprite = Sprite.new()
		trail_sprite.texture = load("res://assets/sprites/playerSprites.png")
		trail_sprite.vframes = 10
		trail_sprite.hframes = 8
		trail_sprite.frame = $Rotatable/Sprite.frame
		trail_sprite.scale.x = 2 * 1.2
		trail_sprite.scale.y = 2 * 1.2
		trail_sprite.scale.x = $Rotatable.scale.x * 2 * 1.2
		trail_sprite.set_script(load("res://assets/scripts/trail_fade.gd"))
		
		get_parent().add_child(trail_sprite)
		trail_sprite.position = position
		trail_sprite.modulate = Color( 1, 0.08, 0.58, 0.5 )
		trail_sprite.z_index = -49
