const std = @import("std");
const stack = @import("stack.zig");

const Self = @This();

/// Type of Number value
pub const Number = i32;

/// Special Stack type of Numbers
const NumbersStack = stack.StaticBufferStack(Number, 64);

const Error = error{
    NullResult,
    NullArg,
    InvalidChar,
    DivisionByZero,
};

/// Available operators
const Operator = enum(u8) {
    Add = '+',
    Sub = '-',
    Mul = '*',
    Div = '/',

    fn process(self: *const Operator, left: Number, right: Number) Error!Number {
        return switch (self.*) {
            .Add => left + right,
            .Sub => left - right,
            .Mul => left * right,
            .Div => if (right == 0) Error.DivisionByZero else @divTrunc(left, right),
        };
    }
};

/// Numbers
numbers_stack: NumbersStack,

pub fn new() Self {
    return Self{ .numbers_stack = NumbersStack.new() };
}

/// Eval the expression
pub fn eval(self: *Self, expression: []const u8) Error!Number {
    var accumulated_number: ?Number = null;

    for (expression, 0..) |char, i| {
        switch (char) {
            '0'...'9' => {
                const digit = char - '0';
                if (accumulated_number == null) {
                    accumulated_number = 0;
                }
                accumulated_number.? = accumulated_number.? * 10 + digit;
            },
            ' ' => {
                try self.processNumber(&accumulated_number);
            },
            '+', '-', '*', '/' => {
                try self.processNumber(&accumulated_number);

                const b = self.numbers_stack.pop() orelse return Error.NullArg;
                const a = self.numbers_stack.pop() orelse return Error.NullArg;

                const op: Operator = @enumFromInt(char);
                const result = try op.process(a, b);

                self.numbers_stack.push(result);

                std.debug.print("{} {c} {} = {}\n", .{ a, char, b, result });
            },
            else => {
                std.debug.print("Unknown char '{c}' at {}\n", .{ char, i });
                return Error.InvalidChar;
            },
        }
    }
    try self.processNumber(&accumulated_number);

    const result = self.numbers_stack.pop() orelse Error.NullResult;

    if (!self.numbers_stack.isEmpty()) {
        std.debug.print("Warn: {} items not used!\n", .{self.numbers_stack.available()});
    }

    return result;
}

fn processNumber(self: *Self, maybe_number: *?Number) Error!void {
    if (maybe_number.*) |number| {
        self.numbers_stack.push(number);
        maybe_number.* = null;
    }
}
