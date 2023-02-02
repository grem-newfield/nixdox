pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'

awful.spawn.with_shell("xmodmap /home/grem/.xmodmap")

require("awful.hotkeys_popup.keys")

-- {{{ ERROR HANDLING
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
    title = "Errors during startup!",
    text = awesome.startup_errors })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Error happened!",
      text = tostring(err) })
    in_error = false
  end)
end

-- {{{ VARS
beautiful.init(gears.filesystem.get_themes_dir() .. "myAssBurn/theme.lua")
terminal = "kitty"
editor = "kitty -e nvim" -- os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e nvim "
Super = "Mod4"
Alt = "Mod1"
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max,
}
-- {{{ WIBAR WIDGET SETUP

function barcontainer(widget)
  local line_and_inputWidget_layout_widget = wibox.widget {
    wibox.widget {
      widget,
      bg = beautiful.yellow,
      widget = wibox.container.background,
    },
    wibox.widget {
      widget = wibox.container.margin,
      top = dpi(10),
      wibox.widget {
        -- top = dpi(10),
        markup = "_________________", -- "     ﱣ   ",
        fg = beautiful.blue,
        bg = beautiful.green,
        -- shape = function(cr, width, height)
        -- gears.shape.rect(cr, width, height)
        -- end,
        widget = wibox.widget.textbox
      },
    },
    spacing = 0,
    layout = wibox.layout.stack
  }
  local container = wibox.widget
  {
    line_and_inputWidget_layout_widget,
    top = dpi(0),
    bottom = dpi(0),
    left = dpi(2),
    right = dpi(2),
    widget = wibox.container.margin
  }
  local box = wibox.widget {
    {
      container,
      top = dpi(2),
      bottom = dpi(0),
      left = dpi(4),
      right = dpi(4),
      widget = wibox.container.margin
    },
    bg = beautiful.lavender,
    shape = helpers.rrect(4),
    -- shape = function(cr, width, height)
    -- gears.shape.rounded_rect(cr, width, height, 4)
    -- end,
    widget = wibox.container.background
  }
  return wibox.widget {
    box,
    top = dpi(3),
    bottom = dpi(0),
    right = dpi(2),
    left = dpi(2),
    widget = wibox.container.margin
  }
end

-- CASTING COUCH
-- local text_widget = wibox.widget {
--   markup = "<span size='xx-large' underline='single'>sus</span>",
--   -- font = beautiful.font,
--   align = "center",
--   valign = "center",
--   widget = wibox.widget.textbox
-- }

local spinnerIcon = gears.surface.load("/home/grem/themeAssets/rudder.png")
local middleSpinnerWidget = wibox.widget {
  {
    image = spinnerIcon,
    widget = wibox.widget.imagebox
  },
  layout = wibox.layout.fixed.horizontal
}

local spinnerTimer = gears.timer {
  timeout = 0.01, autostart = true,
  callback = function()
    spinnerIcon = gears.surface.rotate(spinnerIcon, 1)
  end
}

middleSpinnerWidget:connect_signal("mouse::enter", function()
  spinnerTimer:start()
end)

middleSpinnerWidget:connect_signal("mouse::leave", function()
  spinnerTimer:stop()
end)

-- local showCurrentSongWidget = wibox.widget {
--   layout = wibox.layout.align.horizontal,
--   {
--     -- image = function()
--     --   return awful.spawn("playerctl metadata -p spotify | rg artUrl | awk '{print $NF}'")
--     -- end,
--     widget = wibox.widget.imagebox,
--   },
--   {
--     markup = awful.spawn("playerctl metadata -p spotify | rg title | awk '{print substr($0, index($0,$3))}'") ..
--         "\n" ..
--         awful.spawn("playerctl metadata -p spotify | rg :artist | awk '{print substr($0, index($0,$3))}'") .. "\n",
--     widget = wibox.widget.textbox,
--   }
-- }
--
-- local showCurrentSongWibox = wibox {
--   x = 200, y = 200,
--   width = 500, height = 500,
--   visible = false,
--   ontop = true,
--   bg = beautiful.yellow, fg = beautiful.black,
-- }
--
-- showCurrentSongWibox:set_widget(showCurrentSongWidget)

-- -- Text clock
-- local time = wibox.widget.textclock("<span color='#AD8EE6'></span><span color='#9FA7CA'> %b %d %H:%M </span>")
-- time = barcontainer(time)

local mytextclock = wibox.widget.textclock("%b %d  %H:%M ")

local availablePackagesWidget = awful.widget.watch("bash -c \"doas su grem -c 'doas paru -Sy > /dev/null; paru -Qu | wc -l'\""
  ,
  60 * 60,
  function(widget, stdout)
    local text = ""
    local trim = function(s)
      local from = s:match "^%s*()"
      return from > #s and "" or s:match(".*%S", from)
    end
    text = text .. 'Available updates: '
    text = text .. trim(stdout) .. " "
    for i = 1, stdout do
      text = text .. "";
    end
    text = text .. " "
    if stdout == "0\n" then
      widget:set_text('')
    else
      widget:set_text(text)
    end
  end)

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })


  -- BAR CONSTRUCTOR :0
  -- local my_wibox = wibox({
  --   x = 100,
  --   y = 100,
  --   width = 200,
  --   height = 200,
  --   visible = true,
  --   bg = beautiful.red,
  --   shape = gears.shape.rounded_rect
  -- })
  -- local mywidget = mytextclock
  -- my_wibox:set_widget(mywidget)
  -- awful.screen.connect_for_each_screen(function(s)
  --   s.my_wibox = my_wibox
  -- end)
  -- Add widgets to the wibox
  s.mywibox:setup {
    { -- Left widgets
      s.mytaglist,
      -- s.mypromptbox,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      -- time,
      -- grem_tray,
      -- grem_icon,
      -- middleSpinnerWidget,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Right widgets
      -- wibox.widget.systray(),
      availablePackagesWidget,
      -- wibox.widget { markup = "  ", widget = wibox.widget.textbox },
      mytextclock,
      s.mylayoutbox,
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  }
end)
--
--
--
--
-- }}}

-- {{{ KEY BINDINGS
globalkeys = gears.table.join(
---- HELP D:
-- awful.key(
-- { Super }, "m", function() showCurrentSongWibox.visible = not showCurrentSongWibox.visible end,
-- { description = "show current song", group = "spotify" }
-- ),
  awful.key(
    { Super, }, "KP_Subtract",
    function() awful.spawn.with_shell("setxkbmap dvp && xmodmap /home/grem/.xmodmap_dvorak") end
  ),
  awful.key(
    { Super, }, "KP_Add",
    function() awful.spawn.with_shell("setxkbmap fi && xmodmap /home/grem/.xmodmap") end
  ),
  awful.key(
    { Super, }, "s", hotkeys_popup.show_help,
    { description = "show ", group = "awesome" }
  ),
  awful.key(
    { Super, Alt }, "c",
    function() awful.spawn(editor_cmd .. "/home/grem/.config/awesome/rc.lua") end
    ,
    { description = "open config", group = "awesome" }
  ),
  awful.key(
    { Super, Alt, "Shift" }, "r", function() awful.spawn.with_shell("reboot") end,
    { description = "reboot", group = "awesome" }
  ),
  awful.key(
    { Super, Alt, "Shift" }, "q", function() awful.spawn.with_shell("poweroff") end,
    { description = "power off", group = "awesome" }
  ),
  awful.key(
    { Super, }, "Print",
    function() awful.spawn.with_shell("flameshot gui") end,
    { description = "screenshot", group = "awesome" }
  ),

  -- SPOTIFY
  awful.key(
    { Super, Alt }, "m", function() awful.spawn.with_shell("LD_PRELOAD=/usr/local/lib/spotify-adblock.so spotify") end,
    { description = "summon", group = "spotify" }
  ),
  awful.key(
    { Super, }, "Left", function() awful.spawn.with_shell("playerctl -p spotify previous") end,
    { description = "previous track", group = "spotify" }
  ),
  awful.key(
    { Super, }, "Down", function() awful.spawn.with_shell("playerctl -p spotify play-pause") end,
    { description = "play/pause", group = "spotify" }
  ),
  awful.key(
    { Super, }, "Right", function() awful.spawn.with_shell("playerctl -p spotify next") end,
    { description = "next track", group = "spotify" }
  ),
  -- seek
  awful.key(
    { Super, Alt }, "Left", function() awful.spawn.with_shell("playerctl -p spotify position 5-") end,
    { description = "bck 5s", group = "spotify" }
  ),
  awful.key(
    { Super, Alt }, "Right", function() awful.spawn.with_shell("playerctl -p spotify position 5+") end,
    { description = "fwd 5s", group = "spotify" }
  ),
  -- volume
  awful.key(
    { Super, Alt }, "#123", function() awful.spawn.with_shell("playerctl -p spotify volume 0.01+") end,
    { description = "raise volume", group = "spotify" }
  ),
  awful.key(
    { Super, Alt }, "#122", function() awful.spawn.with_shell("playerctl -p spotify volume 0.01-") end,
    { description = "lower volume", group = "spotify" }
  ),

  -- MAIN VOLUME
  awful.key(
    {}, "#121", function() awful.spawn.with_shell("pw-volume mute toggle") end,
    { description = "toggle mute", group = "sound" }
  ),
  awful.key(
    {}, "#123", function() awful.spawn.with_shell("pw-volume change +0.5%") end,
    { description = "volume up", group = "sound" }
  ),
  awful.key(
    {}, "#122", function() awful.spawn.with_shell("pw-volume change -0.5%") end,
    { description = "volume down", group = "sound" }
  ),

  -- AWESOME
  awful.key(
    { Super, "Control" }, "r", awesome.restart,
    { description = "restart", group = "awesome" }
  ),
  awful.key(
    { Super, "Control" }, "q", awesome.quit,
    { description = "quit", group = "awesome" }
  ),

  -- WINDOWS
  awful.key(
    { Super, }, "c", function() awful.client.focus.byidx(1) end,
    { description = "focus next window", group = "window" }
  ),
  awful.key(
    { Super, }, "l", function() awful.layout.inc(1) end,
    { description = "layout", group = "window" }
  ),

  -- APPS
  awful.key(
    { Super, }, "space", function() awful.spawn.with_shell("rofi -show run") end,
    { description = "summon rofi", group = "apps" }
  ),
  awful.key(
    { Super, }, "f", function() awful.spawn.with_shell(terminal .. " -e lfrun") end,
    { description = "summon rofi", group = "apps" }
  ),
  awful.key(
    { Super, }, "b", function() awful.spawn("env GDK_DPI_SCALE=1.25 brave") end,
    { description = "terminal", group = "apps" }
  ),
  awful.key(
    { Super, }, "k", function() awful.spawn(terminal) end,
    { description = "terminal", group = "apps" }
  )
)


clientbuttons = gears.table.join(
-- MOUSE DRAG WINDOWS
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ Super }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ Super }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

clientkeys = gears.table.join(
-- MORE WINDOWS KEYS
  awful.key(
    { Super, Alt }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "window" }
  ),
  awful.key(
    { Super, }, "w", function(c) c:kill() end,
    { description = "close window", group = "window" }
  ),
  awful.key(
    { Super, }, "t", awful.client.floating.toggle,
    { description = "toggle floating", group = "window" }
  )
)

-- TAGS
for i = 1, 6 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ Super }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ Super, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ Super, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" })
  )
end

-- }}}

root.keys(globalkeys)

-- {{{ RULES
awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },
  {
    rule = { class = "lutris" },
    properties = { floating = true }
  },
  {
    rule = { class = "Ripcord" },
    properties = { floating = true }
  }
}
-- }}}

-- {{{ SIGNALS
client.connect_signal("manage", function(c)
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = true })
  -- local textData = c:name
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  c.opacity = 1.0
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  c.opacity = 1.0
end)

client.connect_signal("property::minimized", function(c)
  c.minimized = false
end)

-- }}}
--
