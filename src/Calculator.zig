const std = @import("std");
const stack = @import("stack.zig");

const Self = @This();

const Number = i32;

const NumbersStack = stack.StaticBufferStack(Number, 64);
const DigitsStack = stack.StaticBufferStack(u8, 32);

const Error = error{
    NullResult,
    NullArg,
    InvalidChar,
    DivisionByZero,
};

const Operator = enum(u8) {
    Plus = '+',
    Minus = '-',
    Star = '*',
    Slash = '/',

    fn process(self: *const Operator, left: Number, right: Number) Error!Number {
        return switch (self.*) {
            .Plus => left + right,
            .Minus => left - right,
            .Star => left * right,
            .Slash => if (right == 0) Error.DivisionByZero else @divTrunc(left, right),
        };
    }
};

numbers_stack: NumbersStack,

pub fn new() Self {
    return Self{ .numbers_stack = NumbersStack.new() };
}

pub fn run(self: *Self, expression: []const u8) Error!Number {
    var digits_stack = DigitsStack.new();

    for (expression, 0..) |char, i| {
        switch (char) {
            '0'...'9' => {
                const digit = char - '0';
                digits_stack.push(digit);
            },
            ' ' => {
                try self.processNumber(&digits_stack);
            },
            '+', '-', '*', '/' => {
                try self.processNumber(&digits_stack);

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
    try self.processNumber(&digits_stack);

    return self.numbers_stack.pop() orelse Error.NullResult;
}

fn processNumber(self: *Self, digits_stack: *DigitsStack) Error!void {
    if (digits_stack.isEmpty()) {
        return;
    }

    const number = try parseNumber(digits_stack);
    self.numbers_stack.push(number);
}

// todo remove digits stack, use only accumulator. Bruh
fn parseNumber(digits_stack: *DigitsStack) Error!Number {
    var number: Number = 0;

    var temp_stack = DigitsStack.new();

    while (digits_stack.pop()) |digit| {
        temp_stack.push(digit);
    }

    while (temp_stack.pop()) |digit| {
        number = number * 10 + digit;
    }

    return number;
}
