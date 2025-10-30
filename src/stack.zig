pub fn StaticBufferStack(comptime T: type, comptime capacity: usize) type {
    return struct {
        const Self = @This();

        buffer: [capacity]T = undefined,
        top_index: usize = 0,

        pub fn new() Self {
            return Self{};
        }

        pub fn push(self: *Self, item: T) void {
            if (self.top_index >= capacity) {
                @panic("Stack overflow");
            }

            self.buffer[self.top_index] = item;
            self.top_index += 1;
        }

        pub fn pop(self: *Self) ?T {
            if (self.isEmpty()) {
                return null;
            }

            self.top_index -= 1;

            return self.buffer[self.top_index];
        }

        pub fn isEmpty(self: *Self) bool {
            return self.top_index == 0;
        }

        pub fn available(self: *Self) usize {
            return self.top_index;
        }
    };
}
