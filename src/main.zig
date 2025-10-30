const std = @import("std");

const print = std.debug.print;

const Calculator = struct {
    const Self = @This();
    const Value = i16;
    const Operator = enum(u8) {
        Plus = '+',
        Minus = '-',
        Star = '*',
        Slash = '/',
    };

    value_stack: std.ArrayList(Value) = undefined,
    value_stack_buffer: [64]Value = undefined,

    pub fn init(self: *Self) void {
        self.value_stack = std.ArrayList(Value).initBuffer(&self.value_stack_buffer);
    }

    pub fn run(self: *Self, expression: []u8) Value {
        for (expression, 0..) |char, i| {
            switch (char) {
                ' ' => {},

                '0'...'9' => {
                    self.value_stack.appendAssumeCapacity(char - '0');
                },

                @intFromEnum(Operator.Plus), @intFromEnum(Operator.Minus), @intFromEnum(Operator.Star), @intFromEnum(Operator.Slash) => {
                    const a = self.value_stack.pop().?;
                    const b = self.value_stack.pop().?;
                    const c = processOperation(@enumFromInt(char), a, b);
                    self.value_stack.appendAssumeCapacity(c);
                },

                else => {
                    print("Unknown char '{c}' at {}\n", .{ char, i });
                },
            }
        }

        return self.value_stack.getLastOrNull() orelse 0;
    }

    fn processOperation(operation: Operator, a: Value, b: Value) Value {
        return switch (operation) {
            Operator.Plus => a + b,
            Operator.Minus => a - b,
            Operator.Slash => @divExact(a, b),
            Operator.Star => a * b,
        };
    }
};

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    var calculator = Calculator{};
    calculator.init();

    const input = try stdin_reader.interface.takeDelimiterExclusive('\n');
    print("Expr: {s}\n", .{input});

    if (input.len > 1) {
        const result = calculator.run(input);
        print("Result: {any}\n", .{result});
    }
}
