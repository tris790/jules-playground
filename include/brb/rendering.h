#ifndef BRB_RENDERING_H
#define BRB_RENDERING_H

#include <SDL2/SDL.h> // For SDL window and renderer

// Using SDL_Window and SDL_Renderer directly for now
// No need for BrbWindow typedef if we pass SDL_Window* directly

SDL_Window* brb_renderer_init_window(int width, int height, const char* title);
SDL_Renderer* brb_renderer_create_renderer(SDL_Window* window); // New function
void brb_renderer_clear_screen(SDL_Renderer* renderer); // Takes renderer
void brb_renderer_present_frame(SDL_Renderer* renderer); // Takes renderer
void brb_renderer_shutdown(SDL_Window* window, SDL_Renderer* renderer); // Takes both

#endif // BRB_RENDERING_H
