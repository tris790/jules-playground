#include <brb/input.h>
#include <stdio.h> // For placeholder prints

void brb_input_poll_events() {
    printf("Input: Polling events (placeholder).\n");
    // In a real SDL implementation, this would be SDL_PollEvent(&event);
}

int brb_input_is_key_pressed(int key_code) {
    printf("Input: Checking if key %d is pressed (placeholder) -> returning 0 (false).\n", key_code);
    // Placeholder: always return 0 (not pressed)
    return 0;
}

void brb_input_get_mouse_position(int* x, int* y) {
    if (x && y) {
        *x = 0; // Placeholder position
        *y = 0; // Placeholder position
        printf("Input: Getting mouse position (placeholder) -> (%d, %d).\n", *x, *y);
    } else {
        printf("Input: Getting mouse position - invalid pointers (placeholder).\n");
    }
}
