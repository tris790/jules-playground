extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1200.0

# var velocity = Vector2.ZERO # Removed: velocity is a built-in property for CharacterBody2D
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
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	# else:
		# Optional: Reset y velocity if on floor and not attempting to jump.
		# This can make landings feel more stable if JUMP_VELOCITY isn't immediately reapplied.
		# Consider if Input.is_action_just_pressed("ui_accept") should also gate this.
		# if velocity.y > 0: # If falling or landed
		#    velocity.y = 0 # Only if not trying to jump in the same frame

	# Conceptual Hitstun Check (structure remains for future use)
	# if hitstun_timer > 0:
	#     hitstun_timer -= delta
	#     # Potentially apply knockback movement here without player input
	#     # Example: velocity.x = move_toward(velocity.x, 0, SOME_HITSTUN_FRICTION * delta)
	# else:
	#     # Handle Player Input only if not in hitstun

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# Apply friction - Godot 4's move_toward is good for this
		velocity.x = move_toward(velocity.x, 0, SPEED) # SPEED here acts as deceleration force.
														 # Consider a separate FRICTION constant if SPEED is too abrupt.

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move the character.
	move_and_slide() # Godot 4: velocity is a property and is updated by move_and_slide

# Conceptual function for applying knockback
# func take_hit(knockback_vector, stun_duration):
#     velocity = knockback_vector # Or velocity += knockback_vector depending on how it's calculated
#     hitstun_timer = stun_duration
#     damage_percentage += 10.0 # Example: take 10% damage
#     print(str(self.name) + " took a hit! Knockback: " + str(knockback_vector) + " Stun: " + str(stun_duration) + " Dmg: " + str(damage_percentage))
