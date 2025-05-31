#ifndef BRB_PHYSICS_H
#define BRB_PHYSICS_H

// Placeholder for physics system
// E.g., collision detection, rigid body dynamics (custom or Bullet)

typedef struct BrbVec2 { float x; float y; } BrbVec2;

void brb_physics_world_step(float delta_time);
// More functions for creating bodies, shapes, etc.

#endif // BRB_PHYSICS_H
