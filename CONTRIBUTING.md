# How to Contribute

* [Coding Conventions](#coding-conventions)
    * [No no's](#no-nos)
    * [If Statements](#if-statements)
    * [Case Statements](#case-statements)

## Coding Conventions

- Use `bash` built-ins wherever possible.
- Try not to pipe (`|`) at all.
- Limit usage of external commands `$(cmd)`.
- Indent 2 spaces.
- Use [snake_case](https://en.wikipedia.org/wiki/Snake_case) for function and variable names.
- Keep lines below `100` characters long.
- Use `[[ ]]` for tests.
- Quote **EVERYTHING**.

### No no's

- Don’t use GNU conventions in commands.
    - Use POSIX arguments and flags.
- Don’t use `cut`.
    - Use `bash`'s built-in [parameter expansion](http://wiki.bash-hackers.org/syntax/pe).
- Don’t use `echo`.
    - Use `printf "%s\n"`
- Don’t use `bc`.
- Don’t use `sed`.
    - Use `bash`'s built-in [parameter expansion](http://wiki.bash-hackers.org/syntax/pe).
- Don’t use `cat`.
    - Use `bash`'s built-in syntax (`file="$(< /path/to/file.txt)")`).
- Don’t use `grep "pattern" | awk '{ printf }'`.
    - Use `awk '/pattern/ { printf }'`
- Don’t use `wc`.
    - Use `${#var}` or `${#arr[@]}`.


### If Statements

If the test only has one command inside of it; use the compact test
syntax. Otherwise the normal `if`/`fi` is just fine.

```sh
# Good (more easily readable to old-school programmers!)
if [[ "$var" ]]; then
    printf "%s\n" "$var"
fi

# Bad (less easily readable to old-school programmers!)
[[ "$var" ]] && printf "%s\n" "$var"
```


### Case Statements

Case statements need to be formatted in a specific way.

```sh
# Good example (Notice the indentation).
case "$var" in
  1)  printf "%s\n" 1 ;;
  2)
      printf "%s\n" "1"
      printf "%s\n" "2"
  ;;

  *)
      printf "%s\n" "1"
      printf "%s\n" "2"
      printf "%s\n" "3"
  ;;
esac
```
