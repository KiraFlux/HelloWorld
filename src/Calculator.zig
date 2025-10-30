const std = @import("std");
const stack = @import("stack.zig");

const Self = @This();

const Value = i32;

const Operator = enum(u8) {
    Plus = '+',
    Minus = '-',
    Star = '*',
    Slash = '/',
};

const Error = error{
    NullResult,
    NullArg,
    InvalidChar,
};

value_stack: stack.StaticBufferStack(Value, 64),

pub fn new() Self {
    return Self{ .value_stack = stack.StaticBufferStack(Value, 64).new() };
}

pub fn run(self: *Self, expression: []u8) Error!Value {
    var digits_stack_buffer: [16]u8 = undefined;
    var digits_stask = std.ArrayList(u8).initBuffer(&digits_stack_buffer);

    for (expression, 0..) |char, i| {
        switch (char) {
            ' ' => { // fixme: number terminates if EOF, OP, SPACE
                var number: Value = 0;
                var power: i32 = 1;

                while (digits_stask.pop()) |digit| {
                    number += digit * power;
                    power *= 10;
                }

                self.value_stack.push(number);
            },

            '0'...'9' => {
                digits_stask.appendAssumeCapacity(char - '0');
            },

            @intFromEnum(Operator.Plus), @intFromEnum(Operator.Minus), @intFromEnum(Operator.Star), @intFromEnum(Operator.Slash) => {
                const a = self.value_stack.pop();
                const b = self.value_stack.pop();

                if (a == null or b == null) {
                    return Error.NullArg;
                }

                const c = try processOperation(@enumFromInt(char), a.?, b.?);
                self.value_stack.push(c);
            },

            else => {
                std.debug.print("Unknown char '{c}' at {}\n", .{ char, i });
                return Error.InvalidChar;
            },
        }
    }

    if (self.value_stack.pop()) |result| {
        return result;
    } else {
        return Error.NullResult;
    }
}

fn processOperation(operation: Operator, a: Value, b: Value) Error!Value {
    return switch (operation) {
        Operator.Plus => a + b,
        Operator.Minus => a - b,
        Operator.Slash => @divTrunc(a, b),
        Operator.Star => a * b,
    };
}
