extends CharacterBody2D

const GRAVITY = 1200.0
# Keep knockback constants if dummy is to be knocked back
const BASE_KNOCKBACK_STRENGTH = 150.0
const KNOCKBACK_SCALE_FACTOR = 5.0

var damage_percentage: float = 0.0
var hitstun_timer: float = 0.0
const SPEED = 300.0 # Retain for hitstun friction calculation, though dummy doesn't walk

var original_color = Color(0.7, 0.7, 0.7, 1.0) # Dummy's default color

# No onready var for hitbox_shape needed

func _ready():
	print_debug("Dummy _ready() called.")
	# No attack timers to setup
	# Set its own original color if Visuals node exists
	var visuals_node = get_node_or_null("Visuals")
	if visuals_node:
		visuals_node.color = original_color
	else:
		print_debug("Dummy Visuals node not found!")
	# No attack timer connections

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if hitstun_timer > 0:
		hitstun_timer -= delta
		# Optional: Apply friction or air resistance during hitstun
		var hitstun_friction_decay_rate = SPEED * 0.5 # Example
		velocity.x = move_toward(velocity.x, 0, hitstun_friction_decay_rate * delta)
	else:
		# Dummy is idle, ensure velocity dampens if not on floor
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 10) # Stronger friction on ground
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * 0.5) # Air resistance


	move_and_slide()

# _on_Hurtbox_area_entered method should be largely the same as player's
# It will react to being hit by a hitbox, take damage, and get knocked back.
func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox": # Or check group
		damage_percentage += 10.0 # Example damage value
		print_debug(str(self.name) + " (Dummy) new damage: " + str(damage_percentage) + "%")

		# Knockback logic (copied and adapted from player.gd)
		var knockback_direction_x = 1.0
		var attacker_node = area.get_parent() # Assumes hitbox is child of attacker
		if attacker_node and self.global_position.x < attacker_node.global_position.x:
			knockback_direction_x = -1.0

		var knockback_angle_rad = deg_to_rad(30)
		var knockback_vector = Vector2(knockback_direction_x * cos(knockback_angle_rad), -sin(knockback_angle_rad))
		knockback_vector = knockback_vector.normalized()

		var total_knockback_strength = BASE_KNOCKBACK_STRENGTH + (damage_percentage * KNOCKBACK_SCALE_FACTOR)
		velocity = knockback_vector * total_knockback_strength

		# Hitstun (set the timer)
		hitstun_timer = 0.3 # Example hitstun duration for dummy, make it slightly different
		print_debug(str(self.name) + " (Dummy) knocked back with velocity: " + str(velocity) + ", hitstun: " + str(hitstun_timer))

		# Visual feedback (copied from player.gd)
		var visuals_node = get_node_or_null("Visuals")
		if visuals_node:
			visuals_node.color = Color(1.0, 0.0, 0.0, 1.0) # Bright red

		var hit_feedback_timer = get_node_or_null("HitFeedbackTimer")
		if not hit_feedback_timer:
			hit_feedback_timer = Timer.new()
			hit_feedback_timer.name = "HitFeedbackTimer"
			add_child(hit_feedback_timer)
			# Bind the dummy's original_color
			hit_feedback_timer.connect("timeout", Callable(self, "_on_hit_feedback_timeout").bind(original_color))

		hit_feedback_timer.wait_time = 0.1
		hit_feedback_timer.one_shot = true
		hit_feedback_timer.start()

# _on_hit_feedback_timeout method is the same as player's
func _on_hit_feedback_timeout(previous_color):
	var visuals_node = get_node_or_null("Visuals")
	if visuals_node:
		visuals_node.color = previous_color

	var hit_feedback_timer = get_node_or_null("HitFeedbackTimer")
	if hit_feedback_timer and hit_feedback_timer.is_stopped(): # Ensure it's stopped before queue_free
			hit_feedback_timer.queue_free()
