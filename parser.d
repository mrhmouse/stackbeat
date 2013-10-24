import
	pegged.grammar,
	std.algorithm,
	std.conv,
	std.stdio,
	std.string;

struct StackBeat
{
	string length;
	string[] commands;

	string toCode()
	{
		auto code = `
		import
			std.algorithm,
			std.array,
			std.stdio;

		const size_t RATE = 8000;
		const size_t DURATION = ` ~ this.length ~ `;

		void pop_two(alias op)(ref size_t[] stack)
		{
			auto a = stack.back;
			stack.popBack;
			auto b = stack.back;
			stack.popBack;

			stack ~= mixin(op);
		}

		void main()
		{
			for (size_t t = 0; t < RATE * DURATION; ++t)
			{
				size_t stack[];
				stack ~= t;
		`;

		foreach (command; this.commands)
		{
			code ~= `
				` ~ command ~ `
			`;
		}

		return strip(outdent(outdent(outdent(code ~ `
				stdout.rawWrite([cast(ubyte)(stack.back & ubyte.max)]);
			}
		}
		`))));
	}
}

StackBeat toStackBeat(ParseTree tree)
{
	StackBeat program;

	string getCommand(string name)
	{
		switch (name)
		{
			case "_":
				return `stack ~= t;`;

			case "@":
				return `stack ~= stack.back;`;

			case "$":
				return `stack.popBack;`;

			case "#":
				return `swap(stack[$ - 1], stack[$ - 2]);`;

			case "~":
				return `stack.back ^= ubyte.max;`;

			case "!":
				return `stack.back = stack.back == 0
					? 1
					: 0;`;

			case ">":
			case "<":
				return `stack.pop_two!"a ` ~ name ~ name ~ ` b";`;

			case "+":
			case "-":
			case "*":
			case "/":
			case "^":
			case "&":
			case "|":
			case "%":
				return `stack.pop_two!"a ` ~ name ~ ` b";`;

			default:
				if (name.isNumeric)
				{
					return `stack ~= ` ~ name ~ `;`;
				}

				return "";
		}
	}

	void walk(ParseTree node)
	{
		switch (node.name)
		{
			case "StackBeat.Length":
				program.length = node.matches[0];
				break;

			case "StackBeat.Command":
				program.commands ~= getCommand(node.matches[0]);
				break;

			default:
		}

		foreach (child; node.children)
		{
			walk(child);
		}
	}

	walk(tree);

	return program;
}

void main(string[] args)
{
	mixin(grammar(`
	StackBeat:
		Program <- Length ':' Command*
		Length <- Number
		Number <~ [0-9]+
		Command <- Number
			/ '_'
			/ '@'
			/ '$'
			/ '#'
			/ '~'
			/ '!'
			/ '+'
			/ '-'
			/ '*'
			/ '/'
			/ '>'
			/ '<'
			/ '^'
			/ '&'
			/ '|'
			/ '%'
	`));

	writeln(StackBeat(args[1]).toStackBeat.toCode);
}
