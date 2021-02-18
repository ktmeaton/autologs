# autologs

[![Test](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml)
[![Lint](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml)

Automatically create commit history, release notes, and a changelog.

## Install

## Local

```bash
git clone https://github.com/ktmeaton/autologs
export PATH=`pwd`/autologs:$PATH
which autologs
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

Creating Auto ListParams with the following parameters.
        Repository:      ktmeaton/autologs
        Commit URL:      https://github.com/ktmeaton/autologs/commit
        Old version:     a4c28c5
        New version:     HEAD
        Max Commits:     20
        Notes Directory: docs/notes
        Output File:     /dev/stdout
        Run:             ListParams
```

### Commit History

```bash
$ autologs --commits --max-commits 5

* [```1f05f16```](https://github.com/ktmeaton/autologs/commit/1f05f16) proper writing to output file
* [```f8c3eed```](https://github.com/ktmeaton/autologs/commit/f8c3eed) bugfix in repo PR url
* [```0915673```](https://github.com/ktmeaton/autologs/commit/0915673) Merge pull request #1 from ktmeaton/dev
* [```369d26b```](https://github.com/ktmeaton/autologs/commit/369d26b) installation docs
* [```656890c```](https://github.com/ktmeaton/autologs/commit/656890c) rename notes dev title
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
* [```1f05f16```](https://github.com/ktmeaton/autologs/commit/1f05f16) proper writing to output file
* [```f8c3eed```](https://github.com/ktmeaton/autologs/commit/f8c3eed) bugfix in repo PR url
```

### Changelog

```bash
$ autologs --changelog --max-commits 5

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
* [```f2333e5```](https://github.com/ktmeaton/autologs/commit/f2333e5) test lint workflow
* [```8983082```](https://github.com/ktmeaton/autologs/commit/8983082) first lint with pre-commit
```

## To Do

- Remove mentions to "ver/version" change to "tag".
- Make PR not dependent on max commits.
- [ ] Github Actions: Test
- [x] Github Actions: Lint

## Credits

Commit History Style: <https://github.com/yuzu-emu/yuzu-mainline/releases>  
Argument Parsing: <https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f>  
Help Function: <https://opensource.com/article/19/12/help-bash-program>
