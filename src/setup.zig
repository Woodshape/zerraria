const rl = @import("raylib");

pub const WINDOW_WIDTH: u32 = 800;
pub const WINDOW_HEIGHT: u32 = 450;
pub const FLOOR: u32 = WINDOW_HEIGHT - TILE_SIZE;

pub const TILE_SIZE: u32 = 32;

pub const PLAYER_START_POSITION: rl.Vector2 = rl.Vector2.init(WINDOW_WIDTH / 2, FLOOR);
pub const JUMPS: u8 = 2;
