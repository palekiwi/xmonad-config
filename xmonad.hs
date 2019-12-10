import System.IO
import System.Exit
import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPane
import XMonad.Layout.PerWorkspace
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "/usr/bin/urxvt"

-- The command to lock the screen or show the screensaver.
myScreensaver = "/usr/bin/xscreensaver-command -l"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "select-screenshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "gscreenshot"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
myLauncher = "$(yeganesh -x -- -fn 'monospace-8' -nb '#000000' -nf '#FFFFFF' -sb '#7C7C7C' -sf '#CEFFAC')"

-- Location of your xmobar.hs / xmobarrc
myXmobarrc = "~/.xmonad/xmobar-single.hs"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
one   = "\xf120"
two   = "\xf268"
three = "\xf27a"
four  = "\xf1b2"
five  = "\xf008"
six   = "\xf17a"

myWorkspaces = [one,two,three,four,five,six] ++ map show [7..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Chromium"           --> doShift two
    , className =? "Google-chrome"      --> doShift two
    , resource  =? "desktop_window"     --> doIgnore
    , className =? "Pidgin"             --> doShift three
    , className =? "Thunderbird"        --> doShift three
    , className =? "Gimp"               --> doShift four
    , className =? "Blender"            --> doShift four
    , className =? "vlc"                --> doShift four
    , className =? "libreoffice-writer" --> doShift four
    , resource  =? "gpicview"           --> doFloat
    , className =? "MPlayer"            --> doFloat
    , className =? "VirtualBox Manager" --> doShift five
    , className =? "Qemu-system-x86_64" --> doShift five
    , className =? "stalonetray"        --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
l0 = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    tabbed shrinkText tabConfig |||
    Full |||
    TwoPane (3/100) (1/2) |||
    Mirror (TwoPane (3/100) (1/2)) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)

l1 = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    TwoPane (3/100) (1/2) |||
    Mirror (TwoPane (3/100) (1/2)) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    Full |||
    spiral (6/7))

l2 = avoidStruts (
    TwoPane (3/100) (1/2) |||
    Tall 1 (3/100) (2/3) |||
    Full)

l3 = avoidStruts (
    spiral (6/7) |||
    Full |||
    TwoPane (3/100) (3/5))

l5 = noBorders (fullscreenFull Full)

myLayout = onWorkspace one l1 $
           onWorkspace two l2 $
           onWorkspace three l3 $
           onWorkspace five l5
           l0

------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
primary = "#5294e2"
myNormalBorderColor  = "#383C4A"
--myFocusedBorderColor = "#7C7C7C"
myFocusedBorderColor = primary

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    --fontName = "xft:SFNS Display:size=10,FontAwesome:size=10",
    activeBorderColor = "#2E3436",
    activeTextColor = "#f3f4f5",
    activeColor = "#2E3436",
    inactiveBorderColor = "#2E3436",
    inactiveTextColor = "#676E7D",
    inactiveColor = "#2E3436"
}

-- Color of current window title in xmobar.
-- xmobarTitleColor = "#f3f4f5"
xmobarTitleColor = primary

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = primary

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod3Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Lock the screen using command specified by myScreensaver.
  , ((modMask .|. controlMask, xK_l),
     spawn myScreensaver)

  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_k),
     spawn myLauncher)

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  , ((modMask .|. controlMask .|. shiftMask, xK_i),
     spawn mySelectScreenshot)

  -- Take a full screenshot using the command specified by myScreenshot.
  , ((modMask .|. shiftMask, xK_i),
     spawn myScreenshot)

  -- Mute volume.
  , ((0, xF86XK_AudioMute),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((0, xF86XK_AudioLowerVolume),
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ((0, xF86XK_AudioRaiseVolume),
     spawn "amixer -q set Master 5%+")

  -- Mute volume.
  , ((modMask .|. controlMask, xK_m),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((modMask .|. controlMask, xK_j),
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ((modMask .|. controlMask, xK_k),
     spawn "amixer -q set Master 5%+")

  {-
  -- Start pomodoro
  , ((modMask, xK_F10),
     spawn "python ~/Apps/i3-gnome-pomodoro/pomodoro-client.py start")
  -- Stop pomodoro
  , ((modMask, xK_F11),
     spawn "python ~/Apps/i3-gnome-pomodoro/pomodoro-client.py stop")
  -}

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "")

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask, xK_b),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_x),
     sendMessage NextLayout)

  -- Jump to full screen.
  , ((modMask, xK_g),
     sendMessage $ JumpToLayout "Full")

  -- Jump to TwoPane
  , ((modMask, xK_n),
    sendMessage $ JumpToLayout "TwoPane")

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_y),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_d),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_q),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_c),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_v),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_d),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_p),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_a),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_j),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask .|. shiftMask, xK_x),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) ([xK_r, xK_s, xK_t, xK_w, xK_f, xK_p] ++ [xK_7 .. xK_9])
      , (f, m) <- [(W.greedyView, 0), (W.shift, controlMask)]]

------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask .|. shiftMask, button1),
      (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
     , ((modMask, button2),
        (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
     , ((modMask, button3),
        (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc <- spawnPipe ("xmobar " ++ myXmobarrc)
  xmonad $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
      }
      , manageHook = manageDocks <+> myManageHook
--      , startupHook = docksStartupHook <+> setWMName "LG3D"
      , startupHook = setWMName "LG3D"
      , handleEventHook = docksEventHook
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
