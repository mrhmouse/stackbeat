module tokenizer;

import
	std.array,
	std.conv;

enum TToken
{
	plus,
	minus,
	product,
	quotient,
	modulo,
	time,
	left_shift,
	right_shift,
	and,
	or,
	xor,
	drop,
	swap,
	dupe,
	number,
	bitwise_not,
	logical_not
}

struct Token
{
	this(TToken type)
	{
		this.type = type;
	}

	this(TToken type, size_t value)
	{
		this.type = type;
		this.value = value;
	}

	TToken type;
	size_t value;
}

Token get(alias type)()
{
	return mixin("Token(TToken." ~ type ~ ")");
}


Token[] tokenize(string input)
{
	Token[] tokens;

	while (!input.empty)
	{
		switch (input.front)
		{
			case '+':
				tokens ~= get!"plus";
				break;

			case '-':
				tokens ~= get!"minus";
				break;

			case '*':
				tokens ~= get!"product";
				break;

			case '/':
				tokens ~= get!"quotient";
				break;

			case '_':
				tokens ~= get!"time";
				break;

			case '@':
				tokens ~= get!"dupe";
				break;

			case '$':
				tokens ~= get!"drop";
				break;

			case '#':
				tokens ~= get!"swap";
				break;

			case '~':
				tokens ~= get!"bitwise_not";
				break;

			case '!':
				tokens ~= get!"logical_not";
				break;

			case '>':
				tokens ~= get!"right_shift";
				break;

			case '<':
				tokens ~= get!"left_shift";
				break;

			case '^':
				tokens ~= get!"xor";
				break;

			case '&':
				tokens ~= get!"and";
				break;

			case '|':
				tokens ~= get!"or";
				break;

			case '%':
				tokens ~= get!"modulo";
				break;

			default:
				tokens ~= Token(TToken.number, parse!size_t(input));
				goto skip_pop;
		}

		input.popFront;

		skip_pop: continue;
	}

	return tokens;
}
