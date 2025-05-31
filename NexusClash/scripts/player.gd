extends KinematicBody2D

const SPEED = 300
const JUMP_VELOCITY = -400
const GRAVITY = 1200

var velocity = Vector2.ZERO
# var hitstun_timer = 0.0 # Conceptual: To be used with hitstun logic
# var damage_percentage = 0.0 # Conceptual: To influence knockback

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

func _physics_process(delta):
	# Apply Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	# else:
		# Optional: Reset y velocity if on floor and not attempting to jump.
		# This can make landings feel more stable if JUMP_VELOCITY isn't immediately reapplied.
		# Consider if Input.is_action_just_pressed("ui_accept") should also gate this.
		# if velocity.y > 0: # If falling or landed
		#    velocity.y = 0

	# Conceptual Hitstun Check
	# if hitstun_timer > 0:
	#     hitstun_timer -= delta
	#     # Skip input processing while in hitstun
	# else:
	#     # Handle Input for Walking (only if not in hitstun)
	#     var direction = 0
	#     if Input.is_action_pressed("ui_left"):
	#         direction -= 1
	#     if Input.is_action_pressed("ui_right"):
	#         direction += 1
	#
	#     if direction != 0:
	#         velocity.x = direction * SPEED
	#     else:
	#         velocity.x = lerp(velocity.x, 0.0, 0.1) # Apply some friction/deceleration
	#
	#     # Handle Input for Jumping (only if not in hitstun and on floor)
	#     if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#         velocity.y = JUMP_VELOCITY

	# Current input handling (to be eventually nested under hitstun check)
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# A bit of friction when no input
		velocity.x = lerp(velocity.x, 0.0, 0.1)

	# Handle Input for Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Apply Movement
	velocity = move_and_slide(velocity, Vector2.UP)

# Conceptual function for applying knockback
# func take_hit(knockback_vector, stun_duration):
#     velocity = knockback_vector # Or velocity += knockback_vector depending on how it's calculated
#     hitstun_timer = stun_duration
#     damage_percentage += 10.0 # Example: take 10% damage
#     print(str(self.name) + " took a hit! Knockback: " + str(knockback_vector) + " Stun: " + str(stun_duration) + " Dmg: " + str(damage_percentage))
