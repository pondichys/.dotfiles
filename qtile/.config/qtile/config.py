import os
import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
mod1 = "alt"
mod2 = "control"

terminal = "kitty"

keys = [
    # Keybindings are mostly defined in sxhkd except those below
    # Shamelessly taken from Erik Dubois' Arcolinux configuration
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "space", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod, "shift"], "x", lazy.shutdown(), desc="Quit Qtile"),

    # Qtile layout 
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),

    # Change focus
    # With arrows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    # With VIM keys
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

def window_to_previous_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen is True:
            qtile.cmd_to_screen(i - 1)

def window_to_next_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen is True:
            qtile.cmd_to_screen(i + 1)

keys.extend([
    # MOVE WINDOW TO NEXT SCREEN
    Key([mod,"shift"], "Right", lazy.function(window_to_next_screen, switch_screen=True)),
    Key([mod,"shift"], "Left", lazy.function(window_to_previous_screen, switch_screen=True)),
])

groups = []

# FOR QWERTY KEYBOARDS
# group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]

# FOR AZERTY KEYBOARDS
group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave",]

group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ", "0",]
# group_labels = ["", "", "", "", "", "", "", "", "", "",]
#group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

#CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift" ], "Tab", lazy.screen.prev_group()),
        Key(["mod1"], "Tab", lazy.screen.next_group()),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        #Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])

colors = []
cache = os.path.expanduser('~/.cache/wal/colors')
def load_colors(cache):
    with open(cache, 'r') as file:
        for i in range(8):
            colors.append(file.readline().strip())
    colors.append('#ffffff')
    lazy.reload()
load_colors(cache)

# Define layouts and layout themes
layout_theme = {
    "margin": 5,
    "border_width": 4,
    "border_focus": colors[1],
    "border_normal": colors[3]
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Floating(**layout_theme),
    layout.Spiral(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# Define widgets

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=2,
    background=colors[0]
)

extension_defaults = widget_defaults.copy()

def init_widgets_list(monitor_num):
    widgets_list = [
        widget.GroupBox(
            font = "JetBrainsMono Nerd Font",
            fontsize = 16,
            margin_y = 2,
            margin_x = 4,
            padding_y = 6,
            padding_x = 6,
            border_width = 2,
            disable_drag = True,
            active = colors[8],
            inactive = colors[1],
            hide_unused = False,
            rounded = False,
            highlight_method = "line",
            highlight_color = [colors[0], colors[0]],
            this_current_screen_border = colors[4],
            this_screen_border = colors[4],
            other_screen_border = colors[3],
            other_current_screen_border = colors[3],
            urgent_alert_method = "line",
            urgent_border = colors[6],
            urgent_text = colors[1],
            foreground = colors[8],
            background = colors[0],
            use_mouse_wheel = False
        ),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0],background = colors[0]),
        widget.TextBox(text = " ", fontsize = 14, font = "JetBrainsMono Nerd Font", foreground = colors[6], background = colors[0]),
        widget.TaskList(
            icon_size = 0,
            font = "JetBrainsMono Nerd Font",
            foreground = colors[7],
            background = colors[3],
            borderwidth = 0,
            border = colors[0],
            margin = 0,
            padding = 8,
            highlight_method = "block",
            title_width_method = "uniform",
            urgent_alert_method = "border",
            urgent_border = colors[0],
            rounded = False,
            txt_floating = " ",
            txt_maximized = " ",
            txt_minimized = " ",
        ),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0],background = colors[0]),
        widget.OpenWeather(
            app_key = "f0f89c0beed4dd9c67ae80ddab4f7f93",
            format = '{icon} {main_temp}°',
            location = "Quenast, BE",
            metric = True,
            font = "JetBrainsMono Nerd Font",
            foreground = colors[8],
        ),
        widget.Sep(linewidth = 0, padding = 10),
        widget.BatteryIcon(
            background = colors[0],
            battery = 1,
        ),
        widget.Sep(linewidth = 0, padding = 10),
        widget.TextBox(text = " ", fontsize = 14, font = "JetBrainsMono Nerd Font", foreground = colors[5]),
        widget.CPU(
            font = "JetBrainsMono Nerd Font",
            update_interval = 1.0,
            format = '{load_percent}%',
            foreground = colors[8],
            padding = 5
        ),
        widget.Sep(linewidth = 0, padding = 10),
        widget.TextBox(text = "󰍛 ", fontsize = 14, font = "JetBrainsMono Nerd Font", foreground = colors[7]),
        widget.Memory(
            font = "JetBrainsMonoNerdFont",
            foreground = colors[8],
            format = '{MemUsed: .0f}{mm} /{MemTotal: .0f}{mm}',
            measure_mem='G',
            padding = 5,
        ),
        widget.Sep(linewidth = 0, padding = 10),
        widget.TextBox(text = " ", fontsize = 14, font = "JetBrainsMono Nerd Font", foreground = colors[6]),
        widget.Clock(format='%H:%M', font = "JetBrainsMono Nerd Font", padding = 10, foreground = colors[8]),
        widget.Systray(background = colors[0], icon_size = 20, padding = 4),
        widget.Sep(linewidth = 1, padding = 10, foreground = colors[0], background = colors[0]),
        widget.CurrentLayoutIcon(scale = 0.5, foreground = colors[0], background = colors[4]),
    ]

    return widgets_list

def init_secondary_widgets_list(monitor_num):
    secondary_widgets_list = init_widgets_list(monitor_num)
    del secondary_widgets_list[16:17]
    return secondary_widgets_list

widgets_list = init_widgets_list("1")
secondary_widgets_list = init_secondary_widgets_list("2")

screens = [
    Screen(top=bar.Bar(widgets=widgets_list, size=36, background=colors[0], margin=5, opacity=0.8),),
    Screen(top=bar.Bar(widgets=secondary_widgets_list, size=36, background=colors[0], margin=6, opacity=0.8),),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/scripts/autostart.sh"])

# Transient windows are floating by default
@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_types = ["notification", "toolbar", "splash", "dialog", "utility", "file_progress", "download", "error"]
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
