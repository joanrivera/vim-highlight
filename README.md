# vim-highlight

This is a fork of http://www.vim.org/scripts/script.php?script_id=1599, I removed the default key maps and exposed the functionality using the `Highlight` command.

Highlight lines or patterns of interest in different colors

### Usage

```vim
:Highlight <mode>   " Highlight depending on <mode> (Ex. :Highlight h)
```

### Modes

* `h` - Highlight line
* `w` - Highlight word under cursor (whole word match)
* `f` - Highlight word under cursor (partial word match)
* `l` - Highlight lines having word under cursor (whole word match)
* `k` - Highlight lines having word under cursor (partial word matching)
* `s` - Highlight last search pattern
* `j` - Highlight all lines having last search pattern
* `a` - Change color for next highlight group
* `r` - Clear last highlight group
* `d` - Clear last pattern highlight
* `n` - Clear all highlights

### Installation

Copy `highlight.vim` to your `.vim/plugin` directory or use a Plugins administrador, such Vundle adding `Plugin 'joanrivera/vim-highlight'` to your `.vimrc` and running `:PluginInstall`.

### Configuration

To define custom colors set the following variables

* `g:lcolor_bg` - Background color for line highlighting
* `g:lcolor_fg` - Foreground color for line highlighting
* `g:pcolor_bg` - Background color for pattern highlighting
* `g:pcolor_fg` - Foreground color for pattern highlighting

### Limitation

If you are using syntax highlighting based on keywords (e.g. language
specific keyword highlighting), then while highlighting lines, if the
line starts with a keyword, then sometimes that keyword is not highlighted,
while the rest of the line is hightlighted normally.

### Acknowledgement

Thanks to *Amit Sethi* `<amitrajsethi@yahoo.com>` for create the original
script
