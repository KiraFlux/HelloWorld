/// Type of Number value
pub const Number = i32;

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

    pub fn process(self: Operator, left: Number, right: Number) !Number {
        return switch (self) {
            .add => left + right,
            .sub => left - right,
            .mul => left * right,
            .div => if (right == 0) Error.DivisionByZero else @divTrunc(left, right),
        };
    }
};
