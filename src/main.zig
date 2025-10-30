const std = @import("std");

const print = std.debug.print;

fn echo(string: []u8) void {
    std.debug.print("-> '{s}'\n", .{string});
}

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    const out = try stdin_reader.interface.takeDelimiterExclusive('\n');
    echo(out);
}
