const std = @import("std");

pub fn main() !void {
    const x = 10;
    const y = x;
    const z = x + y;
    std.debug.print("x + y = z = {}\n", .{z});
}
