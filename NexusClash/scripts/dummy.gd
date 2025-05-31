extends CharacterBody2D

func _ready():
    print_debug("Minimal Dummy _ready() called.")
    print_debug("Dummy script is definitely running its _ready function!")

func _physics_process(delta):
    # Minimal physics process, ensure move_and_slide is called if needed
    # or character will fall through floor if gravity is applied by engine
    # For now, let's keep it truly minimal. If it falls, that's another data point.
    # move_and_slide() # Not strictly needed if no velocity changes
    pass

# Add a simple function to ensure the script is not entirely empty beyond _ready and _physics_process
func test_function():
    pass
