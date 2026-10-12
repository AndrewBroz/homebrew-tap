# homebrew-tap

Homebrew formulae for [prosefix](https://github.com/AndrewBroz/prosefix).

## Install

```sh
brew install andrewbroz/tap/prosefix
```

## What it brings

- `prosefix`, `stylefix` and `proofix` commands (Python, in one isolated virtualenv).
- The tools they drive, installed as Homebrew dependencies: `vale`, `languagetool` and `typos-cli` (`typos`).
- Man pages: `man prosefix`, `man stylefix`, `man proofix`.

Check the setup with `prosefix --doctor`.

## Updating the formula for a new release

1. In `Formula/prosefix.rb`, change `url` and `sha256` to the new sdist (from `https://pypi.org/pypi/prosefix/json`).
2. Rerun `brew update-python-resources andrewbroz/tap/prosefix` to refresh the `resource` blocks (adjudicate, stylefix, proofix, spylls, pyyaml). It reads PyPI with a one-day upload delay, so for a release younger than a day, edit the blocks by hand from the PyPI JSON. Keep spylls on its pure-Python wheel (its sdist cannot be built from source).
3. `brew install --build-from-source andrewbroz/tap/prosefix` and `brew test andrewbroz/tap/prosefix`.
4. `brew audit --strict andrewbroz/tap/prosefix`.
5. Commit and push.
