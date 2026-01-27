**This repo is supposed to used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

## Dependencies

### DOT File Formatting

For Graphviz DOT file formatting on save, you need:

1. **Prettier v2** (compatible with prettier-plugin-dot)
2. **prettier-plugin-dot** plugin

#### Installation

```bash
# Install Prettier v2 and the plugin via Homebrew/npm
npm install -g prettier@^2 prettier-plugin-dot
```

#### Verify Installation

Check that Prettier v2 is installed:
```bash
/opt/homebrew/bin/prettier --version
# Should show: 2.x.x
```

Verify the plugin location:
```bash
ls -la /opt/homebrew/lib/node_modules/prettier-plugin-dot
```

Test formatting manually:
```bash
echo 'digraph G { a -> b; b -> c; }' | /opt/homebrew/bin/prettier --plugin /opt/homebrew/lib/node_modules/prettier-plugin-dot --stdin-filepath test.dot
```

**Note:** The config uses Homebrew's Prettier v2 specifically for DOT files, while Mason's Prettier v3 is used for other file types (JS, TS, CSS, HTML).

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
