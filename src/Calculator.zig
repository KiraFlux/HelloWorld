const std = @import("std");

const stack = @import("stack.zig");

const prelude = @import("prelude.zig");

const Integer = prelude.Integer;
const Error = prelude.Error;
const Operator = prelude.Operator;
const IntegerBuilder = prelude.IntegerBuilder;

const Self = @This();

/// Special Stack type of Numbers
const IntegersStack = stack.StaticBufferStack(Integer, 64);

/// Numbers
numbers_stack: IntegersStack = IntegersStack.new(),
integer_builder: IntegerBuilder = IntegerBuilder.init(),

pub fn new() Self {
    return .{};
}

/// Eval the expression
pub fn eval(self: *Self, expression: []const u8) !Integer {
    for (expression, 0..) |char, i| {
        switch (char) {
            '0'...'9' => {
                self.integer_builder.addDigit(char);
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

fn onNonDigit(self: *Self) void {
    if (self.integer_builder.getAccumulated()) |integer| {
        self.numbers_stack.push(integer);
    }
}

fn onBinaryOperator(self: *Self, operator: Operator) !void {
    const right = self.numbers_stack.pop() orelse return Error.NullArg;
    const left = self.numbers_stack.pop() orelse return Error.NullArg;
    const result = try operator.process(left, right);

    self.numbers_stack.push(result);

    std.debug.print("{} {c} {} = {}\n", .{ left, @intFromEnum(operator), right, result });
}
