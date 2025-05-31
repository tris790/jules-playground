extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1200.0

# Attack State Variables
var is_attacking = false
var attack_startup_timer = Timer.new()
var attack_active_timer = Timer.new()
var attack_endlag_timer = Timer.new()

const ATTACK_STARTUP_DURATION = 0.1 # seconds
const ATTACK_ACTIVE_DURATION = 0.2 # seconds
const ATTACK_ENDLAG_DURATION = 0.15 # seconds

var original_color = Color(0.5, 0.5, 1.0, 1.0) # Store original player color
var attack_color = Color(1.0, 0.5, 0.5, 1.0)   # Reddish color for attack visual

onready var hitbox_shape = $Hitbox/HitboxShape

var damage_percentage: float = 0.0
var hitstun_timer: float = 0.0 # Timer for hitstun state

const BASE_KNOCKBACK_STRENGTH = 150.0
const KNOCKBACK_SCALE_FACTOR = 5.0

# var velocity = Vector2.ZERO # Removed: velocity is a built-in property for CharacterBody2D
# # var hitstun_timer = 0.0 # Conceptual: To be used with hitstun logic # Added above
# # var damage_percentage = 0.0 # Conceptual: To influence knockback # Already added above

# --- Conceptual Combat System Notes ---
#
# **Hitboxes and Hurtboxes:**
# - Hitboxes (for dealing damage/knockback) and Hurtboxes (for receiving hits)
#   will likely be implemented using Area2D nodes as children of the Player.
# - Hurtboxes would typically be always active, representing the character's vulnerable areas.
# - Hitboxes would be enabled only during specific frames of an attack animation.
# - Collision layers and masks will be crucial to ensure hitboxes only interact with
#   opponent hurtboxes and not with the environment or own character.
#
# **Signals:**
# - Hurtboxes would use the 'area_entered' signal to detect incoming hitboxes.
# - The signal callback would then process the hit, apply damage, and knockback.
#
# **Knockback Application:**
# - A function like `apply_knockback(knockback_vector)` would be called on hit.
#   This function would directly modify the `velocity` vector.
#   Example: `velocity += knockback_vector`
# - The `knockback_vector` would be determined by the attacking move's properties
#   (base knockback, knockback scaling, angle) and the target's current damage percentage.
#
# **Damage Percentage:**
# - A variable, e.g., `damage_percentage = 0.0`, will be needed.
# - This percentage will influence the magnitude of the knockback.
#
# **Hitstun:**
# - After being hit, a character should enter a 'hitstun' state for a short duration,
#   preventing any player input. This could be managed with a timer.
#   Example: `var hitstun_timer = 0.0` (declared above with other variables)
# - During `_physics_process`, if `hitstun_timer > 0`, input processing would be skipped.
#
# --- End Conceptual Combat System Notes ---

func _ready():
	add_child(attack_startup_timer)
	add_child(attack_active_timer)
	add_child(attack_endlag_timer)

	attack_startup_timer.connect("timeout", Callable(self, "_on_attack_startup_timeout"))
	attack_active_timer.connect("timeout", Callable(self, "_on_attack_active_timeout"))
	attack_endlag_timer.connect("timeout", Callable(self, "_on_attack_endlag_timeout"))

	attack_startup_timer.one_shot = true
	attack_active_timer.one_shot = true
	attack_endlag_timer.one_shot = true

	var visuals_node = get_node_or_null("Visuals")
	if visuals_node:
		original_color = visuals_node.color
	else:
		print_debug("Player Visuals node not found in _ready!")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Conceptual Hitstun Check & Input Handling
	if hitstun_timer > 0:
		hitstun_timer -= delta
		# Skip player input processing while in hitstun
		# Gravity still applies (already handled above)
		# Horizontal velocity will be affected by knockback, then friction/decay if desired
		# Example friction during hitstun. Note: SPEED might be too strong for friction here.
		# Consider a smaller value or a dedicated hitstun_friction constant.
		# Also, delta is already applied by move_and_slide, so direct manipulation or a separate friction value is better.
		# For now, this is a placeholder to show where hitstun affects movement.
		var hitstun_friction_decay_rate = SPEED * 0.5 # Example: half of normal movement speed for deceleration
		velocity.x = move_toward(velocity.x, 0, hitstun_friction_decay_rate * delta) # Corrected: move_toward expects rate * delta
	else:
		# Handle Attack Input
		if Input.is_action_just_pressed("attack") and not is_attacking and is_on_floor():
			is_attacking = true
			velocity.x = 0 # Stop horizontal movement during attack initiation
			attack_startup_timer.start(ATTACK_STARTUP_DURATION)
			# Optional visual cue for startup
			# var visuals_node = get_node_or_null("Visuals")
			# if visuals_node:
			#     visuals_node.color = Color(0.8, 0.8, 0.5, 1.0) # Yellowish startup

		if is_attacking:
			# If attacking, horizontal movement is stopped (or could be attack-specific movement)
			# Gravity still applies. Jumping is also disabled below.
			pass
		else:
			# Regular Movement Logic (only if not attacking and not in hitstun)
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

		# Handle Jump (only if not attacking and not in hitstun)
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_attacking:
			velocity.y = JUMP_VELOCITY

	# Move the character.
	move_and_slide()

func _on_attack_startup_timeout():
	# Startup phase is over, attack becomes active
	print_debug("Attack Active!")
	var visuals_node = get_node_or_null("Visuals")
	if visuals_node:
		visuals_node.color = attack_color # Change to attack color

	if hitbox_shape:
		# TODO: Position hitbox based on player facing direction
		# For now, always assume facing right for simplicity
		hitbox_shape.disabled = false
		print_debug("Hitbox Enabled")
	else:
		print_debug("HitboxShape node not found in _on_attack_startup_timeout!")

	attack_active_timer.start(ATTACK_ACTIVE_DURATION)

func _on_attack_active_timeout():
	# Active phase is over, hitbox should be disabled
	# Begin endlag
	print_debug("Attack Endlag!")
	var visuals_node = get_node_or_null("Visuals")
	if visuals_node:
		visuals_node.color = original_color # Revert color (or to an endlag color)

	if hitbox_shape:
		hitbox_shape.disabled = true
		print_debug("Hitbox Disabled")

	attack_endlag_timer.start(ATTACK_ENDLAG_DURATION)

func _on_attack_endlag_timeout():
	# Endlag is over, player can act again
	print_debug("Attack Finished.")
	is_attacking = false
	# Ensure color is reverted if not done already
	var visuals_node = get_node_or_null("Visuals")
	if visuals_node and visuals_node.color != original_color:
		 visuals_node.color = original_color

func _on_Hurtbox_area_entered(area):
	# 'area' is the Area2D that entered this hurtbox, which should be a hitbox.
	print_debug(str(self.name) + " Hurtbox detected: " + str(area.get_parent().name) + "/" + str(area.name))
	# We can check if the area is indeed a hitbox by checking its name or group
	# For now, let's assume any area on the correct collision layer/mask is a valid hitbox.
	# A more robust check would be: if area.is_in_group("hitbox"):

	# Check if the area's parent has the "Hitbox" name, which is a common pattern.
	# Or, if the area itself is named "Hitbox" if it's the Area2D node directly.
	# Given our scene structure, area is the Hitbox Area2D node.
	if area.name == "Hitbox":
		damage_percentage += 10.0 # Increment damage
		print_debug(str(self.name) + " new damage: " + str(damage_percentage) + "%")

		# --- Knockback Logic ---
		var knockback_direction_x = 1.0
		# Ensure area.get_parent() is not null before accessing its global_position
		var attacker_node = area.get_parent()
		if attacker_node:
			if self.global_position.x < attacker_node.global_position.x:
				knockback_direction_x = -1.0
		else:
			print_debug("Attacker node (parent of hitbox Area2D) not found for knockback calculation.")
			# Default to knocking away from self if attacker_node is null, though this case should be rare.
			# This might happen if the hitbox area is not parented to an attacker character.
			# For self-hit, this logic might be tricky. Let's assume right knockback.
			pass

		# Create a normalized direction vector (e.g., mostly horizontal with some upward angle)
		var knockback_angle_rad = deg2rad(30) # 30 degrees upward
		var knockback_vector = Vector2(knockback_direction_x * cos(knockback_angle_rad), -sin(knockback_angle_rad))
		knockback_vector = knockback_vector.normalized()

		var total_knockback_strength = BASE_KNOCKBACK_STRENGTH + (damage_percentage * KNOCKBACK_SCALE_FACTOR)

		velocity = knockback_vector * total_knockback_strength
		print_debug(str(self.name) + " knocked back with velocity: " + str(velocity))

		# Conceptual: Set hitstun timer
		# hitstun_timer = 0.2 # Example: 0.2 seconds of hitstun
		# print_debug(str(self.name) + " is in hitstun for " + str(hitstun_timer) + "s")
		# --- End Knockback Logic ---

		print_debug("Hit by a Hitbox named 'Hitbox'!") # Or integrate into the above print

		# Visual feedback
		var visuals_node = get_node_or_null("Visuals")
		if visuals_node:
			visuals_node.color = Color(1.0, 0.0, 0.0, 1.0) # Bright red

			var hit_feedback_timer = get_node_or_null("HitFeedbackTimer") # Check if timer already exists by name
			if not hit_feedback_timer:
				hit_feedback_timer = Timer.new()
				hit_feedback_timer.name = "HitFeedbackTimer"
				# Connect signal only once if timer is reused, or ensure it's fine if connected multiple times (usually is)
				# For dynamically created and freed timers, connecting each time is necessary.
				hit_feedback_timer.connect("timeout", Callable(self, "_on_hit_feedback_timeout").bind(original_color))
				add_child(hit_feedback_timer)

			hit_feedback_timer.wait_time = 0.1 # Set/reset wait time
			hit_feedback_timer.one_shot = true    # Ensure one_shot
			hit_feedback_timer.start()
	else:
		print_debug("Hurtbox detected something that wasn't a Hitbox: " + str(area.name))

func _on_hit_feedback_timeout(previous_color):
	var visuals_node = get_node_or_null("Visuals")
	if visuals_node:
		visuals_node.color = previous_color

	# Clean up the timer if it was added dynamically and named
	# This logic assumes the timer is uniquely named "HitFeedbackTimer" and recreated if needed.
	var hit_feedback_timer = get_node_or_null("HitFeedbackTimer")
	if hit_feedback_timer and hit_feedback_timer.is_stopped(): # Ensure it's stopped before queue_free if it's not one-shot
																# For one-shot, it stops itself.
		hit_feedback_timer.queue_free()

# Conceptual function for applying knockback
# func take_hit(knockback_vector, stun_duration):
#     velocity = knockback_vector # Or velocity += knockback_vector depending on how it's calculated
#     hitstun_timer = stun_duration
#     damage_percentage += 10.0 # Example: take 10% damage
#     print(str(self.name) + " took a hit! Knockback: " + str(knockback_vector) + " Stun: " + str(stun_duration) + " Dmg: " + str(damage_percentage))
