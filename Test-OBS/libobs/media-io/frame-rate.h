#pragma once

#ifdef __cplusplus
extern "C" {
#endif
//
//struct sub_mfps_holder {
//    uint32_t numerator;
//    uint32_t denominator;
//}

struct media_frames_per_second {
	uint32_t numerator;
	uint32_t denominator;
    media_frames_per_second streaming;
    media_frames_per_second recording;
};

static inline double
media_frames_per_second_to_frame_interval(struct media_frames_per_second fps)
{
    if(fps.streaming != null && fps.recording == null) {
        return (double)fps.streaming.denominator
            / fps.streaming.numerator;
    } else if(fps.recording != null) {
        return (double)fps.recording.denominator
        / fps.recording.numerator;
    }
	return (double)fps.denominator / fps.numerator;
}

static inline double
media_frames_per_second_to_fps(struct media_frames_per_second fps)
{
    if(fps.streaming != null && fps.recording == null) {
        return (double)fps.streaming.numerator
            / fps.streaming.denominator
    } else if(fps.recording != null) {
        return (double)fps.recording.numerator
        / fps.recording.denominator
    }
	return (double)fps.numerator / fps.denominator;
}

static inline bool
media_frames_per_second_is_valid(struct media_frames_per_second fps)
{
    
	return (fps.numerator && fps.denominator)
        || fps.streaming != null || fps.recording != null;
}

static inline bool media_frames_per_second_is_multiple(struct media_frames_per_second fps) {
    
    return fps.streaming != null && fps.recording != null;
}



#ifdef __cplusplus
}
#endif
