#include <brb/rendering.h>
#include <stdio.h> // For error messages

SDL_Window* brb_renderer_init_window(int width, int height, const char* title) {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        fprintf(stderr, "Could not initialize SDL: %s\n", SDL_GetError());
        return NULL;
    }

    SDL_Window* window = SDL_CreateWindow(
        title,
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        width,
        height,
        SDL_WINDOW_SHOWN
    );

    if (!window) {
        fprintf(stderr, "Could not create window: %s\n", SDL_GetError());
        SDL_Quit();
        return NULL;
    }
    printf("Window initialized successfully.\n");
    return window;
}

SDL_Renderer* brb_renderer_create_renderer(SDL_Window* window) {
    if (!window) {
        fprintf(stderr, "Window is NULL, cannot create renderer.\n");
        return NULL;
    }
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!renderer) {
        fprintf(stderr, "Could not create renderer: %s\n", SDL_GetError());
        // Window cleanup would happen in the caller or a higher-level shutdown
    } else {
        printf("Renderer created successfully.\n");
    }
    return renderer;
}

// Placeholder for clear_screen, will be implemented in a later step
void brb_renderer_clear_screen(SDL_Renderer* renderer) {
    if (!renderer) return;
    // Set draw color (e.g., black)
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    // printf("Screen cleared (placeholder).\n");
}

// Placeholder for present_frame
void brb_renderer_present_frame(SDL_Renderer* renderer) {
    if (!renderer) return;
    SDL_RenderPresent(renderer);
    // printf("Frame presented (placeholder).\n");
}

void brb_renderer_shutdown(SDL_Window* window, SDL_Renderer* renderer) {
    if (renderer) {
        SDL_DestroyRenderer(renderer);
        printf("Renderer destroyed.\n");
    }
    if (window) {
        SDL_DestroyWindow(window);
        printf("Window destroyed.\n");
    }
    SDL_Quit(); // Quit SDL subsystems
    printf("SDL quit.\n");
}
