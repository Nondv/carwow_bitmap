# Bitmap editor

I tried to keep it simple and not create abstractions unless they were really
needed. For example, I didn't introduce `Color` class even though I suppose I
would in real project (to be fare, I wrote the code the way it can be easily
introduced later).

There's basically only one main abstraction - `Bitmap`.
It encapsulates color data and gives access to it with two mutation methods:

* `#draw_point` that is basic action.
* `#draw_rectangle` that is abstraction over vertical and horizontal segments
  (they are rectangles with width = 1)

`BitmapEditor` is a command processor and basically adapter between Bitmap and
executable. All commands are just plain methods. The main difficulty there are
validations. It's not very clear where they should be. I decided that command
processor should care about arguments' presence and types, and bitmap itself
should care about limitations and further conversions (e.g. colors and 250
length limit).

## Tests

```
rspec
```

There're unit tests for `Bitmap`, some redundant tests for `BitmapEditor` and
some acceptance tests that use executable.

When I wrote acceptance tests `BitmapEditor` tests became useless, but I decided
to keep them anyway.

I wrote them in a first place because I didn't wanna edit executable all the
time, so for my TDD I needed some lower level trivial tests. Here they are.

## Running

```
# cat spec/files/acceptance2.in
bin/bitmap_editor spec/files/acceptance2.in
```
