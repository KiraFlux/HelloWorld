/// Type of Number value
pub const Integer = i32;

pub const Error = error{
    /// Cannot Read Result from Numbers Stack
    NullResult,
    /// Cannot Read one of Operator Args
    NullArg,
    /// Unknown Char in expr
    InvalidChar,
    DivisionByZero,
};

/// Available operators
pub const Operator = enum(u8) {
    add = '+',
    sub = '-',
    mul = '*',
    div = '/',

    pub fn process(self: Operator, left: Integer, right: Integer) !Integer {
        return switch (self) {
            .add => left + right,
            .sub => left - right,
            .mul => left * right,
            .div => if (right == 0) Error.DivisionByZero else @divTrunc(left, right),
        };
    }
};

pub const IntegerBuilder = struct {
    const Self = @This();

    accumulated: ?Integer,

    pub fn init() Self {
        return .{ .accumulated = null };
    }

    pub fn getAccumulated(self: *Self) ?Integer {
        if (self.accumulated) |integer| {
            self.accumulated = null;
            return integer;
        } else {
            return null;
        }
    }

    pub fn addDigit(self: *Self, char: u8) void {
        const base = 10;

        if (self.accumulated == null) {
            self.accumulated = 0;
        }

        self.accumulated.? = self.accumulated.? * base + digitFromChar(char);
    }

    fn digitFromChar(char: u8) u8 {
        return char - '0';
    }
};
