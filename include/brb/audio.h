#ifndef BRB_AUDIO_H
#define BRB_AUDIO_H

// Placeholder for audio system functions (OpenAL Soft / SDL_mixer)
// E.g., loading sounds, playing music, spatial audio

typedef struct BrbSound BrbSound; // Opaque pointer
typedef struct BrbMusic BrbMusic; // Opaque pointer

BrbSound* brb_audio_load_sound(const char* file_path);
void brb_audio_play_sound(BrbSound* sound);
void brb_audio_free_sound(BrbSound* sound);

BrbMusic* brb_audio_load_music(const char* file_path);
void brb_audio_play_music(BrbMusic* music, int loop);
void brb_audio_stop_music();
void brb_audio_free_music(BrbMusic* music);

#endif // BRB_AUDIO_H
