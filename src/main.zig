const std = @import("std");

const print = std.debug.print;

const Calculator = @import("Calculator.zig");

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    var calculator = Calculator.new();

    const input = try stdin_reader.interface.takeDelimiterExclusive('\n');
    print("Expr: {s}\n", .{input});

    if (input.len < 1) {
        return;
    }

    const result = calculator.eval(input);
    print("Result: {any}\n", .{result});
}

fn launch(input: []const u8) Calculator.Number {
    var calculator = Calculator.new();

    if (calculator.eval(input)) |result| {
        return result;
    } else |_| {
        return -999;
    }
}

test "calc test 1" {
    std.debug.assert(launch("10        10*   44       +") == 144);
}

test "calc test 2" {
    std.debug.assert(launch("1 2 + 3 *") == 9);
}

test "calc test 3" {
    std.debug.assert(launch("20 5 * 4 /") == 25);
}
