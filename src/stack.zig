pub fn StaticBufferStack(comptime T: type, comptime capacity: usize) type {
    return struct {
        const Self = @This();

        buffer: [capacity]T = undefined,
        len: usize = 0,

        pub fn new() Self {
            return Self{};
        }

        pub fn push(self: *Self, item: T) void {
            if (self.len >= capacity) {
                @panic("Stack overflow");
            }
            self.buffer[self.len] = item;
            self.len += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.len == 0) {
                return null;
            }
            self.len -= 1;
            return self.buffer[self.len];
        }

        pub fn isEmpty(self: *Self) bool {
            return self.len == 0;
        }
    };
}
