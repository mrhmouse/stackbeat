import
	std.array,
	std.conv,
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

void main(string[] args)
{
	auto duration = parse!size_t(args[1]);
	args[1].popFront;
	auto tokens = args[1].tokenize;

	for (size_t t = 0; t < RATE * duration; ++t)
	{
		size_t[] stack = [t];
		foreach (token; tokens)
		{
			switch (token.type)
			{
				case TToken.plus:
					pop_two!"a + b"(stack);
					break;

				case TToken.minus:
					pop_two!"a - b"(stack);
					break;

				case TToken.product:
					pop_two!"a * b"(stack);
					break;

				case TToken.quotient:
					pop_two!"a / b"(stack);
					break;

				case TToken.modulo:
					pop_two!"a % b"(stack);
					break;

				case TToken.time:
					stack ~= t;
					break;

				case TToken.left_shift:
					pop_two!"a << b"(stack);
					break;

				case TToken.right_shift:
					pop_two!"a >> b"(stack);
					break;

				case TToken.and:
					pop_two!"a & b"(stack);
					break;

				case TToken.or:
					pop_two!"a | b"(stack);
					break;

				case TToken.xor:
					pop_two!"a ^ b"(stack);
					break;

				case TToken.drop:
					stack.popBack;
					break;

				case TToken.swap:
					size_t a = stack.back;
					stack.popBack;
					size_t b = stack.back;
					stack.popBack;
					stack ~= a;
					stack ~= b;
					break;

				case TToken.dupe:
					stack ~= stack.back;
					break;

				case TToken.number:
					stack ~= token.value;
					break;

				case TToken.bitwise_not:
					stack.back = stack.back ^ size_t.max;
					break;

				case TToken.logical_not:
					stack.back = stack.back == 0
						? 1
						: 0;
					break;

				default:
					continue;
			}
		}

		stdout.rawWrite([
			cast(ubyte)(stack.back & ubyte.max)
		]);
	}
}
