# Zig Expression Interpreter

This is my personal project for learning the Zig programming language by building a mathematical expression interpreter.

## Project Overview

I'm exploring Zig by building a practical expression evaluator with reverse Polish notation (RPN). The goal is to understand Zig's features like comptime, manual memory management, and error handling through hands-on implementation.

## Current Features

- Static memory allocation with fixed buffers
- RPN expression evaluation
- Basic arithmetic operations (+, -, *, /)
- Stack-based implementation
- Compile-time checks and error handling

## Building and Testing

```bash
zig build test
```

## Project Structure

- `main.zig` - Entry point and tests
- `Calculator.zig` - Expression evaluator
- `stack.zig` - Static buffer stack implementation

## Plans

1. Extract Lexer (implement regex matching?)
2. Extract Parser (to AST) (Implement Pratt Parser to use traditional infix notation and more operators)
3. Extract Evaluator

## Author Notes

I'm learning Zig because it offers the simplicity and control I wanted in a systems programming language. This project represents my hands-on approach to understanding Zig's unique features and design philosophy.