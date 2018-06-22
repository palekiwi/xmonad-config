-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- https://github.com/vicfryzel/xmonad-config

-- This xmobar config is for a single 4k display (3840x2160) and meant to be
-- used with the stalonetrayrc-single config.
--
-- If you're using a single display with a different resolution, adjust the
-- position argument below using the given calculation.
Config {
    -- Position xmobar along the top, with a stalonetray in the top right.
    -- Add right padding to xmobar to ensure stalonetray and xmobar don't
    -- overlap. stalonetrayrc-single is configured for 12 icons, each 23px
    -- wide.
    -- right_padding = num_icons * icon_size
    -- right_padding = 12 * 23 = 276
    -- Example: position = TopP 0 276
    position = TopP 0 100,
    font = "xft:SFNS Display:size=9,FontAwesome:size=9",
    --font = "xft:ubuntu-10",
    --additionalFonts = [ "xft:FontAwesome:pixelsize=13" ],
    bgColor = "#ffffff",
    fgColor = "#000000",
    lowerOnStart = False,
    overrideRedirect = False,
    allDesktops = True,
    persistent = True,
    commands = [
        --Run Weather "KPAO" ["-t","<tempF>F <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000,
        Run MultiCpu ["-t","<total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#000000","-l","#000000","-n","#000000","-w","3"] 10,
        Run Memory ["-t"," <usedratio>%","-H","8192","-L","4096","-h","#000000","-l","#000000","-n","#000000"] 10,
        --Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#000000","-l","#000000","-n","#000000"] 10,
        --Run Network "eth0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date " %a %b %_d %l:%M" "date" 10,
        --Run Com "getMasterVolume" [] "volumelevel" 10,
        Run StdinReader,
        Run Com "python" ["/home/pawel/Apps/i3-gnome-pomodoro/pomodoro-client.py","status"] "pomodoro" 50
    ],
    sepChar = "%",
    alignSep = "}{",
    --template = "%StdinReader% }{ %multicpu%   %memory%   %eth0%    <fc=#b2b2ff>%volumelevel%</fc>   <fc=#FFFFCC>%date%</fc>"
    template = "%StdinReader% }{ %multicpu%   %memory%  %pomodoro%   <fc=#000000>%date%</fc>"
}
