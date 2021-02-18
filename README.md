# autologs

[![GitHub release](https://img.shields.io/github/release/ktmeaton/autologs/all.svg)](https://GitHub.com/ktmeaton/autologs/releases/)
[![Test](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml)
[![Lint](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml)

Automatically create release notes and a changelog.

## Install

### Executable

```bash
# Download executable
curl https://raw.githubusercontent.com/ktmeaton/autologs/v0.1.0/autologs -o autologs

# Add to path
sudo mv autologs /usr/local/bin/

# Test installation
autologs --help
```

### Git Submodule

```bash
git submodule add https://github.com/ktmeaton/autologs
./autologs/autologs --help
```

## Usage

List parameters autologs will use:

```bash
$ autologs

        Repository:      ktmeaton/autologs
        Commit URL:      https://github.com/ktmeaton/autologs/commit
        Old tag:         a4c28c5
        New tag:         HEAD
        Max Commits:     20
        Notes Directory: docs/notes
        Output File:     /dev/stdout
        Run:             ListParams
```

### Commit History

```bash
$ autologs --commits --max-commits 3

* [```1f05f16```](https://github.com/ktmeaton/autologs/commit/1f05f16) proper writing to output file
* [```f8c3eed```](https://github.com/ktmeaton/autologs/commit/f8c3eed) bugfix in repo PR url
* [```0915673```](https://github.com/ktmeaton/autologs/commit/0915673) Merge pull request #1 from ktmeaton/dev
```

### Release Notes

``` bash
$ autologs --release --new-tag v0.1.0 --max-commits 3

## v0.1.0

### Notes

1. Create repository.
1. Add scripts.
1. Add release workflow.
1. Remove hard-coded variables.
1. Simplify script naming.
1. Create the autologs main executable.
1. Make autologs a standalone executable.

### Pull Requests

* [```pull/2```](https://github.com/ktmeaton/autologs/pull/2) Prelim Commit Documentation
* [```pull/1```](https://github.com/ktmeaton/autologs/pull/1) Installation Docs

### Commits

* [```abe0fe2```](https://github.com/ktmeaton/autologs/commit/abe0fe2) rename notes and fix pr title
* [```c033197```](https://github.com/ktmeaton/autologs/commit/c033197) move new tag naming into release
* [```ce2fded```](https://github.com/ktmeaton/autologs/commit/ce2fded) fix pr dependency on max commits
```

### Changelog

```bash
autologs --changelog
```

See [CHANGELOG.md](https://github.com/ktmeaton/autologs/blob/v0.1.0/CHANGELOG.md) for output.

## Help

```bash
$ autologs --help
Automatically create commit history, release notes, and a changelog.

Syntax: autologs [-h|-v|-o|--old-tag|--new-tag|--max-commits|--notes-dir|--commits|--release]

Options:
        -h, --help        Print this Help.
        -v, --version     Print software version and exit.
        -o, --output      Output file.                                [ default: /dev/stdout ]
        --old-tag         An earlier tag/commit hash to compare to.   [ default: a4c28c5 ]
        --new-tag         A newer tag/commit hash to compare to.      [ default: HEAD ]
        --max-commits     The maximum number of commits to print.     [ default: 20 ]
        --notes-dir       A directory containing manual notees.       [ default: docs/notes ]
        --commits         Print commit history.
        --release         Print release notes.
        --changelog       Print changelog.
```

## Credits

Author: [Katherine Eaton](https://ktmeaton.github.io/)  
Commit History Style: <https://github.com/yuzu-emu/yuzu-mainline/releases>  
Argument Parsing: <https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f>  
Help Function: <https://opensource.com/article/19/12/help-bash-program>
