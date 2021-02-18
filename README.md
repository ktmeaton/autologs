# autologs

[![GitHub release](https://img.shields.io/github/release/ktmeaton/autologs)](https://github.com/ktmeaton/autologs/releases/)
[![Test](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml)
[![Lint](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml)

Automatically create commit history, release notes, and a changelog.

## Install

### Executable

```bash
# Download executable
curl https://raw.githubusercontent.com/ktmeaton/autologs/main/autologs -o autologs

# Add to path
sudo mv autologs /usr/local/bin/

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
$ autologs --release --max-commits 5

## Development

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

* [```365e6aa```](https://github.com/ktmeaton/autologs/commit/365e6aa) test markdown code rendering
* [```a945418```](https://github.com/ktmeaton/autologs/commit/a945418) Merge pull request #2 from ktmeaton/dev
* [```de3dd7f```](https://github.com/ktmeaton/autologs/commit/de3dd7f) start documenting commit usage
```

### Changelog

```bash
$ autologs --changelog --max-commits 3

# CHANGELOG

## Development

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

* [```efe7f5b```](https://github.com/ktmeaton/autologs/commit/efe7f5b) make autologs executable
* [```e47ae92```](https://github.com/ktmeaton/autologs/commit/e47ae92) fix uses typo
* [```3197dc0```](https://github.com/ktmeaton/autologs/commit/3197dc0) test 'test' workflow
```

## Credits

Commit History Style: <https://github.com/yuzu-emu/yuzu-mainline/releases>  
Argument Parsing: <https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f>  
Help Function: <https://opensource.com/article/19/12/help-bash-program>
