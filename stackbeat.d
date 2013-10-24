import
	std.array,
	std.algorithm,
	std.conv,
	std.functional,
	std.stdio,
	tokenizer;

const size_t RATE = 8000;

void pop_two(alias op)(ref size_t[] stack)
{
	size_t a = stack.back;
	stack.popBack;

	size_t b = stack.back;
	stack.popBack;

	size_t c = mixin(op);

	stack ~= c;
}

void plus(ref size_t[] stack, size_t t)
{
	pop_two!"a + b"(stack);
}

void minus(ref size_t[] stack, size_t t)
{
	pop_two!"a - b"(stack);
}

void product(ref size_t[] stack, size_t t)
{
	pop_two!"a * b"(stack);
}

void quotient(ref size_t[] stack, size_t t)
{
	pop_two!"a / b"(stack);
}

void modulo(ref size_t[] stack, size_t t)
{
	pop_two!"a % b"(stack);
}

void left_shift(ref size_t[] stack, size_t t)
{
	pop_two!"a << b"(stack);
}

void right_shift(ref size_t[] stack, size_t t)
{
	pop_two!"a >> b"(stack);
}

void and(ref size_t[] stack, size_t t)
{
	pop_two!"a & b"(stack);
}

void or(ref size_t[] stack, size_t t)
{
	pop_two!"a | b"(stack);
}

void xor(ref size_t[] stack, size_t t)
{
	pop_two!"a ^ b"(stack);
}

void time(ref size_t[] stack, size_t t)
{
	stack ~= t;
}

void dupe(ref size_t[] stack, size_t t)
{
	stack ~= stack.back;
}

void drop(ref size_t[] stack, size_t t)
{
	stack.popBack;
}

void swap(ref size_t[] stack, size_t t)
{
	auto tmp = stack[$ - 1];
	stack[$ - 1] = stack[$ - 2];
	stack[$ - 2] = tmp;
}

void bitwise_not(ref size_t[] stack, size_t t)
{
	stack.back = stack.back ^ size_t.max;
}

void logical_not(ref size_t[] stack, size_t t)
{
	stack.back = stack.back == 0
		? 1
		: 0;
}

auto func_for(Token token)
{
	switch (token.type)
	{
		case TToken.plus:
			return toDelegate(&plus);

		case TToken.minus:
			return toDelegate(&minus);

		case TToken.product:
			return toDelegate(&product);

		case TToken.quotient:
			return toDelegate(&quotient);

		case TToken.modulo:
			return toDelegate(&modulo);

		case TToken.time:
			return toDelegate(&time);

		case TToken.left_shift:
			return toDelegate(&left_shift);

		case TToken.right_shift:
			return toDelegate(&right_shift);

		case TToken.and:
			return toDelegate(&and);

		case TToken.or:
			return toDelegate(&or);

		case TToken.xor:
			return toDelegate(&xor);

		case TToken.drop:
			return toDelegate(&drop);

		case TToken.swap:
			return toDelegate(&swap);

		case TToken.dupe:
			return toDelegate(&dupe);

		case TToken.number:
			return (ref size_t[] stack, size_t t)
			{
				stack ~= token.value;
			};

		case TToken.bitwise_not:
			return toDelegate(&bitwise_not);

		case TToken.logical_not:
			return toDelegate(&logical_not);

		default:
			throw new Exception("Uknown token type");
	}
}

void main(string[] args)
{
	auto duration = parse!size_t(args[1]);
	args[1].popFront;
	auto tokens = args[1].tokenize;

	// Build the command chain.
	auto commands = tokens.map!func_for;

	for (size_t t = 0; t < RATE * duration; ++t)
	{
		size_t[] stack = [t];

		foreach (command; commands)
		{
			command(stack, t);
		}

		stdout.rawWrite([
			cast(ubyte)(stack.back & ubyte.max)
		]);
	}
}
