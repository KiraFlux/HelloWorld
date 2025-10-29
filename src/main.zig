const std = @import("std");
const HelloWorld = @import("HelloWorld");

const print = std.debug.print;

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    const x = 10;
    const y = x;
    const z = x + y;
    print("All your {s} are belong to us.\n", .{"codebase"});
    print("x + y = z = {}\n", .{z});
    try HelloWorld.bufferedPrint();
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
