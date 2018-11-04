# json-type

Guess **Type** from **JSON** values by using Crystal.

```console
$ cat vals.txt
0
1
5
$ json-type vals.txt
Int32

$ cat vals.txt
0
0.1
$ json-type vals.txt
Float64 | Int32
```

## Usecase

If the document's API is inadequate, we often deduce the type from the response JSON.
```console
$ jq . res.json
[
  {
    "id": 10,
    "name": "foo",
    "count": 5,
...

$ jq '[].id' res.json > vals.txt
$ json-type vals.txt
Int32

$ jq '[].name' res.json > vals.txt
$ json-type vals.txt
String | Nil

$ jq '[].count' res.json > vals.txt
$ json-type vals.txt
Float64 | Int32 | String
```

Thus, we can design the struct of the response of the API as follows in Crystal.

```
record Foo,
  id    : Int32,
  name  : String | Nil,
  count : Float64 | Int32 | String
```

## Mechanism

`json-type` simply runs the data as crystal code, and then gets its union type from reflection.

- `vals.txt`
```
0
"foo"
null
```

First, `json-type` puts those data as an `Array` into crystal file named `json-type-source.cr` like this.
```crystal
a = [0, "foo", nil]
puts a.class.to_s
```

Here, `null` or **empty lines** are automatically converted to `nil`.

Second, `json-type` executes the created code by invoking a new `crystal` process.

```console
crystal json-type-source.cr
```

So, note two points.
1. `crystal` should be installed in your environment.
2. be careful that all json data will be executed as crystal codes.


## Development

```console
$ make test
```

## Contributing

1. Fork it (<https://github.com/maiha/json-type/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
