const std = @import("std");
const prelude = @import("prelude.zig");

const Token = union(enum) {
    fn Info(comptime T: type) type {
        return struct {
            lexeme: []u8,
            line: usize,
            col: usize,
            value: T,
        };
    }

    integer: Info(i32),
    operator: Info(prelude.Operator),
};

pub const Lexer = struct {
    const Self = @This();

    tokens: std.ArrayList(Token),

    pub fn process(source: []const u8) !void {
        _ = source;
    }
};
