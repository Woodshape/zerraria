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

    const player_idle_texture = try rl.loadTexture("assets/Dude_Monster_Idle_4.png");
    defer rl.unloadTexture(player_idle_texture);

    var p: player.Player = player.Player.default();
    var idle_animation: animation.Animation = .{
        .first_frame = 0,
        .last_frame = 3,
        .current_frame = 0,
        .duration = 0.1,
        .duration_left = 0.1,
        .animation_type = .Repeating,
    };

    var velocity_y: f32 = 0.0;
    var jump_number: u8 = 0;
    var isGrounded: bool = false;
    var player_direction: animation.AnimationDirection = .Right;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        const velocity_x: f32 = 1 * 100 * rl.getFrameTime();

        if (rl.isKeyDown(.d) or rl.isKeyDown(.right)) {
            p.position.x += velocity_x;
            player_direction = .Right;
        }
        if (rl.isKeyDown(.a) or rl.isKeyDown(.left)) {
            p.position.x -= velocity_x;
            player_direction = .Left;
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

        if (p.position.y > constants.FLOOR - (constants.TILE_SIZE * 2)) {
            jump_number = 0;
            isGrounded = true;
            velocity_y = 0.0;
            p.position.y = constants.FLOOR - (constants.TILE_SIZE * 2);
        }

        idle_animation.animation_update();

        var player_rect = idle_animation.animation_frame(4);
        player_rect.width *= @floatFromInt(@intFromEnum(player_direction));

        rl.drawTexturePro(player_idle_texture, player_rect, .{
            .x = p.position.x,
            .y = p.position.y,
            .width = 100,
            .height = 100,
        }, .{
            .x = 10,
            .y = 10,
        }, 0.0, .white);
    }
}

test "test" {
    try std.testing.expect(true);
}
