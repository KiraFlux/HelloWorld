const std = @import("std");

const print = std.debug.print;

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    const out = try stdin_reader.interface.takeDelimiterExclusive('\n');
    print("Typed: {s}\n", .{out});
}
