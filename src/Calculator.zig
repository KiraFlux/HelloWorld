const std = @import("std");
const stack = @import("stack.zig");
const prelude = @import("prelude.zig");

const Number = prelude.Number;
const Error = prelude.Error;
const Operator = prelude.Operator;

const Self = @This();

/// Special Stack type of Numbers
const NumbersStack = stack.StaticBufferStack(Number, 64);

/// Numbers
numbers_stack: NumbersStack = NumbersStack.new(),
accumulated_number: ?Number = undefined,

pub fn new() Self {
    return .{};
}

/// Eval the expression
pub fn eval(self: *Self, expression: []const u8) !Number {
    self.accumulated_number = null;

    for (expression, 0..) |char, i| {
        switch (char) {
            '0'...'9' => {
                self.onDigit(char);
            },
            ' ' => {
                self.onNonDigit();
            },
            '+', '-', '*', '/' => {
                self.onNonDigit();
                try self.onBinaryOperator(@enumFromInt(char));
            },
            else => {
                std.debug.print("Unknown char '{c}' at {}\n", .{ char, i });
                return Error.InvalidChar;
            },
        }
    }
    self.onNonDigit();

    const result = self.numbers_stack.pop() orelse Error.NullResult;

    if (!self.numbers_stack.isEmpty()) {
        std.debug.print("Warning! {} numbers not used!\n", .{self.numbers_stack.available()});
    }

    return result;
}

fn toDigit(char: u8) u8 {
    return char - '0';
}

fn onDigit(self: *Self, char: u8) void {
    const base = 10;

    if (self.accumulated_number == null) {
        self.accumulated_number = 0;
    }
    self.accumulated_number.? = self.accumulated_number.? * base + toDigit(char);
}

fn onNonDigit(self: *Self) void {
    if (self.accumulated_number) |number| {
        self.numbers_stack.push(number);
        self.accumulated_number = null;
    }
}

fn onBinaryOperator(self: *Self, operator: Operator) !void {
    const right = self.numbers_stack.pop() orelse return Error.NullArg;
    const left = self.numbers_stack.pop() orelse return Error.NullArg;
    const result = try operator.process(left, right);

    self.numbers_stack.push(result);

    std.debug.print("{} {c} {} = {}\n", .{ left, @intFromEnum(operator), right, result });
}
