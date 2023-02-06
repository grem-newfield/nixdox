local themes_path = require("gears.filesystem").get_themes_dir()
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main
local theme = {}
theme.wallpaper = "/home/grem/Pictures/Wallpapers/black_yellow.png"
-- }}}

-- {{{ Styles
theme.font = "Victor Mono Bold 16"

-- {{{ Colors
theme.green = "#A5FB8F"
theme.blue = "#9FFCEA"
theme.lavender = "#9183F7"
theme.red = "#FF0000"
theme.yellow = "#ffd700"
theme.black = "#000000"
theme.ink = "#93857E"

theme.fg_normal = theme.black
theme.fg_focus  = "#F0DFAF"
theme.fg_urgent = "#CC9393"
theme.bg_normal = theme.yellow
theme.bg_focus  = "#1E2320"
theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
theme.useless_gap   = 0 --dpi(4)
theme.border_width  = dpi(2)
theme.border_normal = theme.black
theme.border_focus  = theme.yellow
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}


-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "myAssBurn/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "myAssBurn/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
