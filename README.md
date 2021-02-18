# autologs

Automatically document commit history, release notes, and a changelog.

## Install

## Local

```
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

Print the last 5 commits.

```bash
$ autologs --commits --max-commits 5

* [```1f05f16```](https://github.com/ktmeaton/autologs/commit/1f05f16) proper writing to output file
* [```f8c3eed```](https://github.com/ktmeaton/autologs/commit/f8c3eed) bugfix in repo PR url
* [```0915673```](https://github.com/ktmeaton/autologs/commit/0915673) Merge pull request #1 from ktmeaton/dev
* [```369d26b```](https://github.com/ktmeaton/autologs/commit/369d26b) installation docs
* [```656890c```](https://github.com/ktmeaton/autologs/commit/656890c) rename notes dev title
```

Print commits between two tags.

```
autologs --commits --old-ver v0.1.0 --new-ver v0.1.1
```

## To Do

- Remove mentions to "ver/version" change to "tag".

## Credits

Commit History Style: <https://github.com/yuzu-emu/yuzu-mainline/releases>  
Argument Parsing: <https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f>  
Help Function: <https://opensource.com/article/19/12/help-bash-program>
