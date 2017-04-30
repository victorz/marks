# marks

Marks consists of a handful of shell functions that comprise a bookmarking
system for the command line. Bookmarks are saved as symlinks in a folder
(`$MARKSPATH`).

This project was inspired by the simplicity of a concept described in [this
article][1], and born out of frustration of another similar project known as
`apparix`.

[1]: http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html

## Functions

* `to` -- visit a mark or directory (`cd` replacement)
* `mark` -- create a new mark
* `rmmark` -- remove a mark
* `marks` -- list all marks

## Example usage session

```Shell
$ marks
No bookmarks.
$ pwd
/home/victor/docs/recipes
$ mark
new mark: recipes -> /home/victor/docs/recipes
$ ls
sauces/ soups/ pastry/
$ cd soups
$ mark supps # mark with custom name
new mark: supps -> /home/victor/docs/recipes/soups
$ cd ..
$ mark ./sauces sassies # mark specified dir with custom name
new mark: sassies -> /home/victor/docs/recipes/sauces
$ marks
recipes -> /home/victor/docs/recipes
sassies -> /home/victor/docs/recipes/sauces
supps -> /home/victor/docs/recipes/soups
$ to # same as `cd`
$ pwd
/home/victor
$ to recipes # goto mark
$ pwd
/home/victor/docs/recipes
$ to - # same as `cd -`
~
$ to supps
$ pwd
/home/victor/docs/recipes/soups
```
