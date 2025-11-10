const std = @import("std");
const rl = @import("raylib");

const setup = @import("./setup.zig");

pub const Player = struct {
    position: rl.Vector2,
    jumps: usize = undefined,

    pub fn default() Player {
        return .{ .position = setup.PLAYER_START_POSITION, .jumps = setup.JUMPS };
    }

    pub fn init(position: rl.Vector2, jumps: usize) Player {
        return .{ .position = position, .jumps = jumps };
    }

    pub fn canJump(self: *Player, jumps_taken: u8) bool {
        return jumps_taken < self.jumps;
    }
};

test "player defaults" {
    const player: Player = Player.default();
    try std.testing.expectEqual(setup.JUMPS, player.jumps);
    try std.testing.expect(player.position.x != 0 and player.position.y != 0);
    try std.testing.expectEqual(player.position, setup.PLAYER_START_POSITION);
}

test "player can jump" {
    const jumps: usize = 2;
    var player: Player = .{
        .position = rl.Vector2.zero(),
        .jumps = jumps,
    };
    try std.testing.expectEqual(jumps, player.jumps);
    try std.testing.expect(player.canJump(0));
    try std.testing.expect(player.canJump(1));
    try std.testing.expect(!player.canJump(2));
}
