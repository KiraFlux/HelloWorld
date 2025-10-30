const std = @import("std");

const print = std.debug.print;

const Calculator = @import("Calculator.zig");

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    var calculator = Calculator{};
    calculator.init();

    const input = try stdin_reader.interface.takeDelimiterExclusive('\n');
    print("Expr: {s}\n", .{input});

    if (input.len < 1) {
        return;
    }

    const result = calculator.run(input);
    print("Result: {any}\n", .{result});
}
