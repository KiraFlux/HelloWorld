const std = @import("std");

pub fn StaticBufferStack(comptime T: type, comptime capacity: usize) type {
    return struct {
        const Self = @This();

        buffer: [capacity]T = undefined,
        container: std.ArrayList(T) = undefined,

        pub fn new() Self {
            var self = Self{};

            self.container = std.ArrayList(T).initBuffer(&self.buffer);

            return self;
        }

        pub fn push(self: *Self, item: T) void {
            self.container.appendAssumeCapacity(item);
        }

        pub fn pop(self: *Self) ?T {
            return self.container.pop();
        }
    };
}
