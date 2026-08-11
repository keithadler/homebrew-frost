# homebrew-frost

A Homebrew tap for [frost](https://github.com/keithadler/frost), a shell
scripting language for the era when machines write the scripts and humans only
get to review them.

```bash
brew install keithadler/frost/frost
frost init
```

## What frost is

A command is argv, never a string, so a value can never become syntax and
there is no `eval` to reach for. Every script can be read before it runs:

```bash
frost --explain deploy.frost     # every program, file, host and secret it touches
frost --check --strict deploy.frost   # exits 1 on a dangerous verdict
frost --policy site.policy deploy.frost   # refuse what the policy forbids
```

## Other ways to install

`pip install frostlang` is the primary route and always has the newest
release. This tap exists for people who would rather not `pip install` a shell
tool. There is also a container at `ghcr.io/keithadler/frost` for pipelines.

The keystore extra is not included here, because it needs a real cipher and
most installs will not use it. Add it with `pip install "frostlang[keystore]"`
if you need encrypted secrets.

## Updating the formula

The formula points at a specific sdist on PyPI, by URL and hash. To move it to
a new release, take both from
`https://pypi.org/pypi/frostlang/<version>/json` and open a pull request.
