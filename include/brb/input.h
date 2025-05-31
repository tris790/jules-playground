#ifndef BRB_INPUT_H
#define BRB_INPUT_H

// Placeholder for input handling system (SDL2 based)
// E.g., keyboard, mouse, gamepad state

void brb_input_poll_events();
int brb_input_is_key_pressed(int key_code); // Key codes would be defined elsewhere or via SDL
void brb_input_get_mouse_position(int* x, int* y);

#endif // BRB_INPUT_H
