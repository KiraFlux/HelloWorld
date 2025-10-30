const std = @import("std");

const print = std.debug.print;

const Calculator = struct {
    value_stack: std.ArrayList(i16),

    pub fn run(self: *Calculator, expression: []u8) i16 {
        for (expression, 0..) |char, i| {
            switch (char) {
                ' ' => {},

                '0'...'9' => {
                    self.value_stack.appendAssumeCapacity(char - '0');
                },

                '+', '-', '*', '/' => {
                    const a = self.value_stack.pop().?;
                    const b = self.value_stack.pop().?;
                    const c = processOperation(char, a, b);
                    self.value_stack.appendAssumeCapacity(c);
                },

                else => {
                    print("Unknown char '{c}' at {}\n", .{ char, i });
                },
            }
        }

        return self.value_stack.getLast();
    }

    fn processOperation(operation: u8, a: i16, b: i16) i16 {
        return switch (operation) {
            '+' => a + b,
            '-' => a - b,
            '/' => @divExact(a, b),
            '*' => a * b,
            else => unreachable,
        };
    }
};

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    const input = try stdin_reader.interface.takeDelimiterExclusive('\n');
    print("Expr: {s}\n", .{input});

    var calculator_value_stack_buffer: [64]i16 = undefined;
    var calculator = Calculator{
        .value_stack = std.ArrayList(i16).initBuffer(&calculator_value_stack_buffer),
    };

    const result = calculator.run(input);
    print("Result: {any}\n", .{result});
}
