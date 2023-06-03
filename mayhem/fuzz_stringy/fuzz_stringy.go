package fuzz_camel_case

import "github.com/gobeam/stringy"

func Fuzz(data []byte) int {
	if len(data) < 1 {
		return -1
	}

	var selector = data[0] % 3
	var input = string(data[1:])

	str := stringy.New(input)

	if selector == 0 {
		_ = str.CamelCase("?", "")
	}

	if selector == 1 {
		_ = str.SnakeCase("?", "")
	}

	if selector == 2 {
		_ = str.KebabCase("?", "")
	}

	return 0
}