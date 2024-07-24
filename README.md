# Calculator

Adds together, the comma-separated numbers given in a string, and returns the result.

## Usage

```rb
calculator = Calculator.new
calculator.add("1,5") # => 6
```

### Even works with just one number

```rb
calculator.add("1") # => 1
```

### Returns zero when the string is empty

```rb
calculator.add("") # => 0
```

### Handles new lines

When the string contains a new line in between, it treats it as a comma.

```rb
calculator.add("1\n2,3") # => 6
```

### Supports different delimiter

Prepending the string with `"//[delimiter]\n"` will make it use that delimiter, instead of the default comma. For example,

```rb
calculator.add("//;\n1;2") # => 3
```

Here, `";"` acts as the delimiter.

### Raises an error when negative numbers are present

Raises the `Calculator::NegativeNumbersNotAllowedError` when negative numbers are detected.

```rb
calculator.add("-1,2,-3")
# => raises Calculator::NegativeNumbersNotAllowedError with the message: "negative numbers not allowed -1, -3"
```

## Testing

```bash
$ bundle exec rspec
```
