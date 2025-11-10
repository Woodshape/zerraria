const std = @import("std");
const rl = @import("raylib");
const constants = @import("./constants.zig");

pub const AnimationType = enum { Repeating, OneShot };

pub const AnimationDirection = enum(i2) { Left = -1, Right = 1 };

pub const Animation = struct {
    first_frame: i32,
    last_frame: i32,
    current_frame: i32,
    step: i32 = 1,

    duration: f32,
    duration_left: f32,

    animation_type: AnimationType,

    const tile_size = constants.ANIMATION_TILE_SIZE;

    pub fn animation_update(self: *Animation) void {
        const dt: f32 = rl.getFrameTime();
        self.duration_left -= dt;

        if (self.duration_left <= 0) {
            self.duration_left = self.duration;
            self.current_frame += self.step;

            if (self.current_frame > self.last_frame) {
                switch (self.animation_type) {
                    .Repeating => {
                        self.current_frame = self.first_frame;
                    },
                    .OneShot => {
                        self.current_frame = self.last_frame;
                    },
                }
            } else if (self.current_frame < self.first_frame) {
                switch (self.animation_type) {
                    .Repeating => {
                        self.current_frame = self.last_frame;
                    },
                    .OneShot => {
                        self.current_frame = self.first_frame;
                    },
                }
            }
        }
    }

    pub fn animation_frame(self: *Animation, num_frames_per_row: i32) rl.Rectangle {
        // const current_frame = @as(f32, @floatFromInt(self.current_frame));
        // const num_frames = @as(f32, @floatFromInt(num_frames_per_row));
        const x: i32 = @rem(self.current_frame, num_frames_per_row) * tile_size;
        const y: i32 = @divTrunc(self.current_frame, num_frames_per_row) * tile_size;

        return rl.Rectangle{
            .x = @as(f32, @floatFromInt(x)),
            .y = @as(f32, @floatFromInt(y)),
            .width = tile_size,
            .height = tile_size,
        };
    }
};
