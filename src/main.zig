const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

const prelude = @import("prelude.zig");
const Integer = prelude.Integer;
const Error = prelude.Error;

const Calculator = @import("Calculator.zig");

pub fn main() !void {
    // var stdin = std.fs.File.stdin();
    // var stdin_buffer: [1024]u8 = undefined;
    // var stdin_reader = stdin.reader(&stdin_buffer);
}

fn launch(input: []const u8) !Integer {
    var calculator = Calculator.new();
    return calculator.eval(input);
}

fn launchNoError(input: []const u8) Integer {
    if (launch(input)) |result| {
        return result;
    } else |_| {
        return -696969;
    }
}

test "Error.DivisionByZero" {
    assert(launch("1 0 /") == Error.DivisionByZero);
}

test "Error.NullArg" {
    assert(launch("1 +") == Error.NullArg);
}

test "Error.InvalidChar" {
    assert(launch("omuamua") == Error.InvalidChar);
}

test "Error.NullResult" {
    assert(launch("") == Error.NullResult);
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
