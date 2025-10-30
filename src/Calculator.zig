const std = @import("std");
const print = std.debug.print;

const Self = @This();

pub const Value = i32;

pub const Operator = enum(u8) {
    Plus = '+',
    Minus = '-',
    Star = '*',
    Slash = '/',
};

pub const Error = error{
    Generic,
    NullArg,
    InvalidChar,
};

value_stack_buffer: [64]Value = undefined,
value_stack: std.ArrayList(Value) = undefined,

pub fn init(self: *Self) void {
    self.value_stack = std.ArrayList(Value).initBuffer(&self.value_stack_buffer);
}

pub fn run(self: *Self, expression: []u8) Error!Value {
    for (expression, 0..) |char, i| {
        switch (char) {
            ' ' => {},

            '0'...'9' => {
                self.value_stack.appendAssumeCapacity(char - '0');
            },

            @intFromEnum(Operator.Plus), @intFromEnum(Operator.Minus), @intFromEnum(Operator.Star), @intFromEnum(Operator.Slash) => {
                const a = self.value_stack.pop();
                const b = self.value_stack.pop();

                if (a == null or b == null) {
                    return Error.NullArg;
                }

                const c = try processOperation(@enumFromInt(char), a.?, b.?);
                self.value_stack.appendAssumeCapacity(c);
            },

            else => {
                print("Unknown char '{c}' at {}\n", .{ char, i });
                return Error.InvalidChar;
            },
        }
    }

    return self.value_stack.getLastOrNull() orelse 0;
}

fn processOperation(operation: Operator, a: Value, b: Value) Error!Value {
    return switch (operation) {
        Operator.Plus => a + b,
        Operator.Minus => a - b,
        Operator.Slash => @divTrunc(a, b),
        Operator.Star => a * b,
    };
}
