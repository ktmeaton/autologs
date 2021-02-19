# <img src="https://raw.githubusercontent.com/ktmeaton/pixilart/master/logos/autologs/autologs_640px.png" height="320"/>

[![GitHub release](https://img.shields.io/github/release/ktmeaton/autologs/all.svg)](https://github.com/ktmeaton/autologs/releases/)
[![Test](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/test.yaml)
[![Lint](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml/badge.svg)](https://github.com/ktmeaton/autologs/actions/workflows/lint.yaml)

Automatically create release notes and a changelog.

## Install

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
autologs --commits --max-commits 3
```

* [```1f05f16```](https://github.com/ktmeaton/autologs/commit/1f05f16) proper writing to output file
* [```f8c3eed```](https://github.com/ktmeaton/autologs/commit/f8c3eed) bugfix in repo PR url
* [```0915673```](https://github.com/ktmeaton/autologs/commit/0915673) Merge pull request #1 from ktmeaton/dev

### Release Notes

``` bash
autologs --release --old-tag v0.1.0 --new-tag v0.1.1 --max-commits 5
```

**v0.1.1**

**Notes**

1. Deploy to Github Pages.

**Pull Requests**

* [```pull/3```](https://github.com/ktmeaton/autologs/pull/3) Fix Jekyll Config

**Commits**

* [```4d43066```](https://github.com/ktmeaton/autologs/commit/4d43066) Merge pull request #3 from ktmeaton/dev
* [```ed21463```](https://github.com/ktmeaton/autologs/commit/ed21463) fix jekyll config linting
* [```bd19b91```](https://github.com/ktmeaton/autologs/commit/bd19b91) Merge branch 'main' of https://github.com/ktmeaton/autologs into main
* [```fc54f6f```](https://github.com/ktmeaton/autologs/commit/fc54f6f) alternate way of showing output
* [```a949079```](https://github.com/ktmeaton/autologs/commit/a949079) Set theme jekyll-theme-slate

The optional section "### Notes" will appear if a notes file matching the tag name exists.
The notes file must contain an enumerated list of notes.

```yaml
autologs parameters:
  --new-tag v0.1.0
  --notes-dir docs/notes/

matching file: docs/notes/Notes_v0.1.0.md
  1. Create repository
  1. Add scripts.
  1. Add release workflow.
```

### Changelog

```bash
autologs --changelog -o CHANGELOG.md
```

See [CHANGELOG.md](https://github.com/ktmeaton/autologs/blob/main/CHANGELOG.md) for full output.

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
