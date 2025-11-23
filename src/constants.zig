const rl = @import("raylib");

pub const WINDOW_WIDTH: u32 = 800;
pub const WINDOW_HEIGHT: u32 = 450;

pub const ANIMATION_TILE_SIZE: u32 = 32;
pub const ANIMATION_PLAYER_WIDTH: u32 = 100;
pub const ANIMATION_PLAYER_HEIGHT: u32 = 100;

pub const PLAYER_START_POSITION: rl.Vector2 = rl.Vector2.init(WINDOW_WIDTH / 2, 100);
pub const JUMPS: u8 = 2;

pub fn toI32(x: anytype) i32 {
    return @intFromFloat(x);
}

pub fn toF32(x: anytype) f32 {
    return @floatFromInt(x);
}
