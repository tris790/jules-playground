#include <stdio.h>
#include <brb/core.h>
#include <SDL2/SDL.h> // Required for SDL_Delay

int main(int argc, char *argv[]) {
    (void)argc; // Unused parameter
    (void)argv; // Unused parameter

    printf("Brain Rot Brawl - C99 Engine - Initializing...\n");

    BrbEngineCore engine_core_instance; // Create an instance
    // It's good practice to zero-initialize structs
    engine_core_instance.window = NULL;
    engine_core_instance.renderer = NULL;
    engine_core_instance.is_running = 0;


    brb_engine_initialize(&engine_core_instance);

    // Main loop will be called here in the next step
    // if (engine_core_instance.is_running) {
    //    brb_engine_run_main_loop(&engine_core_instance);
    // } else {
    //    fprintf(stderr, "Failed to initialize engine. Exiting.\n");
    // }

    // For now, just init and shutdown to test window creation
    if (engine_core_instance.window && engine_core_instance.renderer) {
        printf("Window and renderer initialized. Shutting down for this test.\n");
        SDL_Delay(2000); // Keep window open for 2 seconds to see it
    } else {
        fprintf(stderr, "Engine initialization failed. Exiting.\n");
    }


    brb_engine_shutdown(&engine_core_instance);

    printf("Brain Rot Brawl - C99 Engine - Exited.\n");
    return 0;
}
