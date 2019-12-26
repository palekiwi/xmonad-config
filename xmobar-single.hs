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
    --position = TopP 0 240,
    position = TopP 0 120,
    --font = "xft:SFNS Display:size=10,FontAwesome:size=10",
    font = "xft:Ubuntu:style=Medium:size=11,Font Awesome 5 Free:style=Solid:size=10,Font Awesome 5 Brands:style=Regular:size=10",
    --font = "xft:ubuntu-10",
    --additionalFonts = [ "xft:FontAwesome:pixelsize=13" ],
    bgColor = "#2F343F",
    fgColor = "#BABDB6",
    lowerOnStart = False,
    overrideRedirect = False,
    allDesktops = True,
    persistent = True,
    commands = [
        --Run Weather "KPAO" ["-t","<tempF>F <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000,
        Run MultiCpu ["-t"," <total>%", "-m","2","-c", "0","-L","30","-H","60","-h","#EB484F","-l","#5DE489","-n","#BABDB6"] 10,
        Run Memory ["-t"," <usedratio>%","-H","8192","-L","4096","-h","#EB484F","-l","#5DE489","-n","#BABDB6"] 10,
        Run DiskU [("/home", " <free>")] ["-L", "5", "-H", "50","-h","#5DE489","-l","#EB484F", "-m", "1", "-p", "3"] 20,
        --Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        --Run Network "eth0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        --Run Com "/home/pawel/.xmonad/bin/getMasterVolume" [] "volumelevel" 10,
        --Run Com "/home/pawel/.xmonad/bin/getMasterVolumePercent" [] "volumelevel" 10,
        Run Com "/home/pawel/.xmonad/bin/showInboxTasks" [] "inbox" 10,
        Run Com "/home/pawel/.xmonad/bin/nextTask" [] "next" 10,
        --Run Com "/home/pawel/.xmonad/bin/pomodoro" ["status", "-f", "| %c |"] "count" 10,
        --Run Com "/home/pawel/.xmonad/bin/pomodoro" ["status", "-f", "%r"] "pomodoro" 10,
        Run CatInt 0 "/home/pawel/.elapsed" ["-L","40","-H","80","-h","#EB484F","-l","#5DE489","-n","#f0c674"] 60,
        Run StdinReader
    ],
    sepChar = "*",
    alignSep = "}{",
    --template = "%StdinReader% }{ %multicpu%   %memory%   %eth0%    <fc=#b2b2ff>%volumelevel%</fc>   <fc=#FFFFCC>%date%</fc>"
    --template = "*StdinReader* }{ *multicpu*   *memory*   *disku*        <fc=#5DE489>*inbox*</fc>   [ <fc=#f0c674>*next*</fc> ]    *cat0*% *count* <fc=#f0c674>*pomodoro*</fc>      <fc=#D3D7CF>*date*</fc>"
    template = "*StdinReader* }{ *multicpu*   *memory*   *disku*        <fc=#5DE489>*inbox*</fc>   [ <fc=#f0c674>*next*</fc> ]    *cat0*%     <fc=#D3D7CF>*date*</fc>"
}
