const std = @import("std");
const ArrayList = std.ArrayList;

const prelude = @import("prelude.zig");
const Operator = prelude.Operator;
const Error = prelude.Error;
const Integer = prelude.Integer;

const Token = union(enum) {
    const Position = u16;

    fn Info(comptime T: type) type {
        return struct {
            lexeme: []u8,
            line: Position,
            col: Position,
            value: T,
        };
    }

    integer: Info(i32),
    operator: Info(Operator),
};

pub const Lexer = struct {
    const Self = @This();

    tokens: ArrayList(Token),

    pub fn process(self: *Self, source: []const u8, gpa: std.mem.Allocator) !void {
        var col: Token.Position = 0;
        var row: Token.Position = 0;
        for (source, 0..) |char, i| {
            switch (char) {
                ' ' => {},
                '\n' => {
                    row += 1;
                    col = 0;
                },
                '+', '-', '*', '/' => {
                    try self.tokens.append(gpa, Token{ .operator = .{
                        .lexeme = source[i .. i + 1],
                        .line = row,
                        .col = col,
                        .value = @enumFromInt(char),
                    } });
                },
                else => {
                    return Error.InvalidChar;
                },
            }
            col += 1;
        }
    }
};
