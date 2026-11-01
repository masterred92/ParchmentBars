std = "lua51"
max_line_length = false
exclude_files = { "tests/**", "tools/**", ".release/**", ".lua/**", ".luarocks/**", "wow-ui/**", "index/**", "hosts/**" }
-- Our own globals.
globals = { "SLASH_PARCHMENTBARS1", "SlashCmdList" }
-- WoW API (checked against Blizzard's UI source by tools/verify_api.py) and host-addon globals (tools/host_api.py).
read_globals = { "BigWigsAPI" }
