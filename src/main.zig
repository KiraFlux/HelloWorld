const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

const Calculator = @import("Calculator.zig");

pub fn main() !void {
    var stdin = std.fs.File.stdin();
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = stdin.reader(&stdin_buffer);

    var calculator = Calculator.new();

    const input = try stdin_reader.interface.takeDelimiterExclusive('\n');
    print("Expr: {s}\n", .{input});

    const result = calculator.eval(input);
    print("Result: {any}\n", .{result});
}

fn launch(input: []const u8) Calculator.Error!Calculator.Number {
    var calculator = Calculator.new();
    return calculator.eval(input);
}

fn launchNoError(input: []const u8) Calculator.Number {
    if (launch(input)) |result| {
        return result;
    } else |_| {
        return -696969;
    }
}

test "Calculator.Error.DivisionByZero" {
    assert(launch("1 0 /") == Calculator.Error.DivisionByZero);
}

test "Calculator.Error.NullArg" {
    assert(launch("1 +") == Calculator.Error.NullArg);
}

test "Calculator.Error.InvalidChar" {
    assert(launch("omuamua") == Calculator.Error.InvalidChar);
}

test "Calculator.Error.NullResult" {
    assert(launch("") == Calculator.Error.NullResult);
}

test "single" {
    assert(launchNoError("420") == 420);
}

test "1" {
    assert(launchNoError("10        10*   44       +") == 144);
}

test "2" {
    assert(launchNoError("1 2 + 3 *") == 9);
}

test "3" {
    assert(launchNoError("20 5 * 4 /") == 25);
}
