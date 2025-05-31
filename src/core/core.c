#include <brb/core.h>
#include <brb/input.h> // Will be needed for event loop
#include <stdio.h>

// BrbEngineCore G_BrbEngine; // Definition if using global

void brb_engine_initialize(BrbEngineCore* engine) {
    if (!engine) {
        fprintf(stderr, "Engine core pointer is null.\n");
        return;
    }

    engine->window = brb_renderer_init_window(800, 600, "Brain Rot Brawl");
    if (!engine->window) {
        fprintf(stderr, "Failed to initialize window.\n");
        engine->is_running = 0; // Stop if window fails
        return;
    }

    engine->renderer = brb_renderer_create_renderer(engine->window);
    if (!engine->renderer) {
        fprintf(stderr, "Failed to create renderer.\n");
        brb_renderer_shutdown(engine->window, NULL); // Clean up window
        engine->window = NULL;
        engine->is_running = 0; // Stop if renderer fails
        return;
    }
    engine->is_running = 1; // Ready to run
    printf("Core engine initialized successfully.\n");
}

// Main loop will be fleshed out in the next step
void brb_engine_run_main_loop(BrbEngineCore* engine) {
    if (!engine || !engine->is_running) {
        fprintf(stderr, "Engine not initialized or not set to run.\n");
        return;
    }
    printf("Core engine main loop starting (placeholder)...\n");

    // Basic loop structure for now, event handling will be added next
    // while (engine->is_running) {
    //     brb_input_poll_events(); // Placeholder for now
    //
    //     // Check if quit event was processed by input system
    //     // if (brb_input_should_quit()) { // Function to be added in input.h/c
    //     //     engine->is_running = 0;
    //     // }
    //
    //     brb_renderer_clear_screen(engine->renderer);
    //     // ... game logic and rendering ...
    //     brb_renderer_present_frame(engine->renderer);
    //
    //     SDL_Delay(16); // Approx 60 FPS, crude delay
    // }
    printf("Core engine main loop finished (placeholder).\n");
}

void brb_engine_shutdown(BrbEngineCore* engine) {
    if (!engine) return;
    brb_renderer_shutdown(engine->window, engine->renderer);
    engine->window = NULL;
    engine->renderer = NULL;
    engine->is_running = 0;
    printf("Core engine shutdown complete.\n");
}
