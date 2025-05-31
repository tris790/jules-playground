#ifndef BRB_GAMEPLAY_H
#define BRB_GAMEPLAY_H

// Placeholder for game-specific logic and structures
// E.g., character management, stage interactions, game rules

typedef struct BrbPlayer BrbPlayer; // Opaque
typedef struct BrbStage BrbStage;   // Opaque

void brb_gameplay_update(float delta_time);
// Functions for loading characters, stages, managing game state etc.

#endif // BRB_GAMEPLAY_H
