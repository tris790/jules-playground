#ifndef BRB_RENDERING_H
#define BRB_RENDERING_H

// Placeholder for rendering system functions
// E.g., window creation, graphics initialization (Vulkan/OpenGL), drawing primitives

typedef struct BrbWindow BrbWindow; // Opaque pointer

BrbWindow* brb_renderer_init_window(int width, int height, const char* title);
void brb_renderer_clear_screen();
void brb_renderer_present_frame(BrbWindow* window);
void brb_renderer_shutdown(BrbWindow* window);

#endif // BRB_RENDERING_H
