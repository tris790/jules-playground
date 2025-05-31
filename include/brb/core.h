#ifndef BRB_CORE_H
#define BRB_CORE_H

#include <brb/rendering.h> // For SDL_Window, SDL_Renderer

// Placeholder for core engine functions and structures
typedef struct {
    SDL_Window* window;
    SDL_Renderer* renderer;
    int is_running; // To control the main loop
} BrbEngineCore;

// Global engine instance (simplification for now)
// extern BrbEngineCore G_BrbEngine;

void brb_engine_initialize(BrbEngineCore* engine); // Pass struct to initialize
void brb_engine_run_main_loop(BrbEngineCore* engine);
void brb_engine_shutdown(BrbEngineCore* engine);

#endif // BRB_CORE_H
