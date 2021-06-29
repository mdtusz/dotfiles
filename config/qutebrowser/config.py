# Defaults file can be created with `:config-write-py -d`

import socket

config.load_autoconfig()

c.auto_save.session = True
c.backend = "webengine"

c.colors.messages.error.bg = "#ee1010"

c.colors.tabs.bar.bg = "black"
c.colors.tabs.even.bg = "black"
c.colors.tabs.odd.bg = "black"
c.colors.tabs.odd.fg = "white"

c.colors.tabs.indicator.start = "#444444"
c.colors.tabs.indicator.stop = "#00aaaa"

c.colors.tabs.selected.even.bg = "#444444"
c.colors.tabs.selected.odd.bg = "#555555"

c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = "auto"

c.completion.height = 256

c.confirm_quit = ["always"]

c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
]
c.content.blocking.whitelist = []

c.fonts.default_family = ["Inter-Light"]
c.fonts.default_size = "10pt"

HOSTNAME = socket.gethostname()
HIGH_DPI_HOSTS = ["iota", "delta", "lambda"]
if HOSTNAME == "kappa":
    c.qt.highdpi = False
    c.zoom.default = "150%"
elif HOSTNAME in HIGH_DPI_HOSTS:
    c.qt.highdpi = True
    c.zoom.default = "100%"

c.statusbar.show = "always"

c.tabs.background = False
c.tabs.indicator.padding = {"top": 0, "bottom": 0, "left": 1, "right": 4}
c.tabs.indicator.width = 2
c.tabs.max_width = 256
c.tabs.min_width = -1
c.tabs.mode_on_change = "restore"
c.tabs.new_position.related = "last"
c.tabs.padding = {"top": 2, "bottom": 2, "left": 0, "right": 5}

c.url.default_page = "https://google.com/"
c.url.start_pages = ["https://aon3d.slack.com"]
c.url.searchengines = {
    "DEFAULT": "http://google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
}

config.bind("<Shift-Escape>", "mode-leave", mode="passthrough")
config.bind("<Ctrl-Shift-}>", "tab-next")
config.bind("<Ctrl-Shift-{>", "tab-prev")
