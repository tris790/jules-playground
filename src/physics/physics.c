#include <brb/physics.h>
#include <stdio.h> // For placeholder prints

void brb_physics_world_step(float delta_time) {
    printf("Physics: Stepping world by %f seconds (placeholder).\n", delta_time);
}

// Example of how you might use BrbVec2 if you had more functions
void brb_physics_apply_force(BrbVec2 force_vector) {
    printf("Physics: Applying force (%f, %f) (placeholder).\n", force_vector.x, force_vector.y);
}
