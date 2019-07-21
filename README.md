# vim-locstack

Manage location stack per window just like basic vim tag.

# Usage

## Command

```
SaveLocation
" Save current location.

NextLocation
" Jump to next location.

PrevLocation
" Jump to previous location.

ListLocations
" List locations in stack. You can jump where you want.

ClearLocations
" Clear location stack.
```

## Function

```
locstack#save()
" Save current location.

locstack#next()
" Jump to next location.

locstack#prev()
" Jump to previous location.

locstack#list()
" List locations in stack. You can jump where you want.

locstack#clear()
" Clear location stack.

locstack#save_then(cmd)
" Save current location then execute `cmd`. This function is intended to use
" together with other plugins.
"    call locstack#save_then("call CocAction('jumpDefinition')")
"      or
"    call locstack#save_then({-> CocAction('jumpDefinition')})
```

## Command & key map

| Function         | Command        | Key map                  |
| -                | -              | -                        |
| locstack#save()  | SaveLocation   | \<Plug\>(locstack-save)  |
| locstack#next()  | NextLocation   | \<Plug\>(locstack-next)  |
| locstack#prev()  | PrevLocation   | \<Plug\>(locstack-prev)  |
| locstack#list()  | ListLocations  | \<Plug\>(locstack-list)  |
| locstack#clear() | ClearLocations | \<Plug\>(locstack-clear) |
