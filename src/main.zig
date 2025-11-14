const std = @import("std");
const rl = @import("raylib");

const constants = @import("./constants.zig");
const player = @import("./player.zig");
const animation = @import("./animation.zig");

const print = std.debug.print;

pub const GRAVITY: f32 = 600.0;
pub const JUMP_FORCE: f32 = -300.0;

pub fn main() !void {
    rl.initWindow(constants.WINDOW_WIDTH, constants.WINDOW_HEIGHT, "raylib zig example");
    defer rl.closeWindow();

    const player_idle_texture: rl.Texture2D = try rl.loadTexture("assets/Dude_Monster_Idle_4.png");
    defer rl.unloadTexture(player_idle_texture);
    const player_run_texture: rl.Texture2D = try rl.loadTexture("assets/Dude_Monster_Run_6.png");
    defer rl.unloadTexture(player_run_texture);

    var p: player.Player = player.Player.default();
    var player_animation: animation.Animation = .{
        .last_frame = 3,
        .duration = 0.1,
        .duration_left = 0.1,
    };

    var velocity_y: f32 = 0.0;
    var jump_number: u8 = 0;
    var isGrounded: bool = false;
    var player_direction: animation.AnimationDirection = .Right;
    var player_texture: rl.Texture2D = undefined;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        const speed: f32 = 2 * 100 * rl.getFrameTime();
        var isMoving: bool = false;

        if (rl.isKeyDown(.d) or rl.isKeyDown(.right)) {
            p.position.x += speed;
            player_direction = .Right;
            isMoving = true;
        }
        if (rl.isKeyDown(.a) or rl.isKeyDown(.left)) {
            p.position.x -= speed;
            player_direction = .Left;
            isMoving = true;
        }
        if (rl.isKeyPressed(.space) and p.canJump(jump_number)) {
            jump_number += 1;
            velocity_y = JUMP_FORCE;
            isGrounded = false;
        }

        if (!isGrounded) {
            velocity_y += GRAVITY * rl.getFrameTime();
            p.position.y += velocity_y * rl.getFrameTime();
        }

        if (p.position.y + constants.ANIMATION_PLAYER_HEIGHT > constants.WINDOW_HEIGHT) {
            jump_number = 0;
            isGrounded = true;
            velocity_y = 0.0;
            p.position.y = constants.WINDOW_HEIGHT - constants.ANIMATION_PLAYER_HEIGHT;
        }

        player_texture = if (isMoving) player_run_texture else player_idle_texture;

        player_animation.animation_update(rl.getFrameTime);

        var player_rect = player_animation.animation_frame(4);
        player_rect.width *= @floatFromInt(@intFromEnum(player_direction));

        rl.drawTexturePro(player_texture, player_rect, .{
            .x = p.position.x,
            .y = p.position.y,
            .width = constants.ANIMATION_PLAYER_WIDTH,
            .height = constants.ANIMATION_PLAYER_HEIGHT,
        }, .{
            .x = 0,
            .y = 0,
        }, 0.0, .white);
    }
}

test "test" {
    try std.testing.expect(true);
}
