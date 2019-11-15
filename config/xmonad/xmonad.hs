import XMonad
import XMonad.Hooks.ManageHelpers        -- for centering floating windows
import XMonad.Hooks.SetWMName            -- for Java apps
import XMonad.Util.EZConfig              -- append key/mouse bindings
import qualified XMonad.StackSet as W    -- for overriding default greedyview setting on dual monitor
import qualified Data.Map as M
import XMonad.Actions.DwmPromote         -- swap master like dwm
import XMonad.Actions.CycleWindows       -- classic alt-tab
import XMonad.Actions.CycleWS            -- cycle workspaces
import XMonad.Hooks.EwmhDesktops         -- for rofi/wmctrl
import XMonad.Layout.ResizableTile       -- for resizeable tall layout
import XMonad.Layout.MouseResizableTile  -- for mouse control
import XMonad.Layout.ThreeColumns        -- for three column layout
import XMonad.Layout.Grid                -- for additional grid layout
import XMonad.Layout.Minimize            -- for hiding windows
import XMonad.Layout.NoBorders           -- for fullscreen without borders
import XMonad.Layout.Fullscreen          -- fullscreen mode
import XMonad.Layout.Spacing             -- Add some bling spacing
import XMonad.Layout.Tabbed              -- Tabbed layout
import XMonad.Layout.ToggleLayouts       -- Quickly switch layout
import XMonad.Layout.TwoPane             -- Handy twopane layout
import XMonad.Util.Scratchpad            -- dropdown urxvtc
import XMonad.Util.Themes                -- for tabbed layout

-- Named workspaces
myWorkspaces = [
		  "1: Sys"
		, "2: WWW"
		, "3: Devel"
		, "4: FM"
		, "5: Image"
		, "6: Util1"
		, "7: IM"
		, "8: Misc1"
		, "9: Misc2"
	       ]

startupWorkspace = "2: WWW"

-- TODO: Add actions to automatically move applications to workspaces on launch
myManageHook = composeAll
    [ title     =? "floatingurxvtc"        --> doCenterFloat
    , className =? "feh"                   --> doFloat
    , className =? "Xfe"                   --> moveTo "4: FM"
    , className =? "Xfe"                   --> doFloat
    , className =? "MPlayer"               --> doFloat
    , className =? "vlc"                   --> doFloat
    , className =? "gnome-calculator"      --> doFloat
    , title     =? "Calculator"            --> doFloat
    , className =? "Firefox"               --> moveTo "2: WWW"
    , className =? "Geeqie"                --> moveTo "5: Image"
    , className =? "Emacs"                 --> moveTo "3: Devel"
    , className =? "TelegramDesktop"       --> moveTo "7: IM"
    , resource  =? "desktop_window"        --> doIgnore
    , resource  =? "kdesktop"              --> doIgnore ]
    where
    	moveTo = doF . W.shift

-- Pop-up terminal a la Yakuake/Guake etc.
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.25  -- terminal height, 10%
    w = 0.6   -- terminal width, 100%
    t = 0     -- distance from top edge, 90%
    l = 0.2   -- distance from left edge, 0%


myTabConfig = def { inactiveBorderColor = "#FF000", activeTextColor = "#ff3300" }

-- Layouts
myLayout = ResizableTall 1 (1/10) (5/9) []
           ||| Mirror ( ResizableTall 1 (10/100) (5/9) [] )
	   ||| TwoPane (5/100) (5/9)
	   ||| tabbed shrinkText (theme kavonAutumnTheme)
           ||| Grid
           ||| ThreeColMid 1 (1/10) (1/2)

-- Non-numeric num pad keys, sorted by number
-- (Don't seem to work for workspace switching)
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
             , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
             , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
             , xK_KP_Insert]                            -- 0

-- Windows key as modifier
modm = mod4Mask

-- Keybindings
myKeys = [ ("M1-<Tab>"   , cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab ) -- classic alt-tab behaviour
         , ("M-<Return>" , dwmpromote                                  ) -- swap the focused window and the master window
         , ("M-<Right>"  , nextWS                                      ) -- go to next workspace
         , ("M-<Left>"   , prevWS                                      ) -- go to prev workspace
         , ("M-S-<Right>", shiftToNext                                 ) -- move client to next workspace
         , ("M-S-<Left>" , shiftToPrev                                 ) -- move client to prev workspace
         , ("M-c"        , spawn "gnome-calculator"                    ) -- calc
	 , ("M-<Esc>"    , spawn mySmallBlueTerminal                   ) -- floating terminal
	 , ("M-<F1>"     , spawn "synapse"                             ) -- spawn synapse launcher
         , ("M-<F2>"     , spawn "rofi -show run"                      ) -- rofi app launcher
         , ("M-<F3>"     , spawn "rofi -show window"                   ) -- rofi window switch
         , ("M-<F4>"     , spawn "cheatsheet sgl"                      ) -- cheatsheet app
         , ("M-<F5>"     , spawn "nvim-qt /home/aren/.xmonad/xmonad.hs") -- edit config
	 , ("M-<F12>"    , scratchPad                                  ) -- dropdown urxvtc
         , ("M-r"        , spawn "xmonad --restart"                    ) -- restart xmonad w/o recompiling
         , ("M-b"        , spawn "firefox"                             ) -- launch browser
      	 , ("M-p"        , spawn "keepassxc"                           ) -- launch keepassxc
	 , ("M-e"        , spawn "emacsclient -nc -s instance1"        ) -- launch Spacemacs (emacs daemon client)
         , ("M-v"        , spawn "nvim-qt"                             ) -- launch nvim editor
         , ("M-s"        , spawn "spectacle"                           ) -- launch system top
         , ("M-f"        , spawn "xfe"                                 ) -- launch xfe file manager
         , ("M-m"        , spawn "mindforger"                          ) -- launch mindforger
         , ("M-w"        , spawn "taskcoach.py"                        ) -- launch task coach
         , ("M-i"        , spawn "telegram"                            ) -- launch telegram IM
	 , ("M-n"        , spawn "nvim-qt -- -u ~/.SpaceVim/vimrc"     ) -- launch SpaceVim
	 , ("M-u"        , spawn "/usr/lib/kde4/libexec/kdesu muon"    ) -- lanuch muon package manager
         , ("M-z"        , prevScreen                                  ) -- switch screen
	 , ("M-g"        , moveTo Next HiddenNonEmptyWS                ) -- next empty workspace
         , ("M-S-f"      , sendMessage ToggleLayout                    ) -- switch to fullscreen layout

	 -- VI style keybindings to move/expand/shrink window frames
	 -- <meta>+<shift>+h/l : resize horizontally
	 -- <meta>+<shift>+j/k : resize vertically
	 -- <meta>+h/l         : rotate master window frame clockwise/anticlockwise
	 -- <meta>+j/k         : change focus clockwise/anticlockwise

         , ("M-S-z"      , shiftPrevScreen                             ) -- move window to other screen
	 , ("M-S-h"      , sendMessage Shrink                          )
	 , ("M-S-l"      , sendMessage Expand                          )
	 , ("M-S-j"      , sendMessage MirrorShrink                    )
	 , ("M-S-k"      , sendMessage MirrorExpand                    )
	 , ("M-h"        , windows W.swapUp                            )
	 , ("M-l"        , windows W.swapDown                          )
         ]
         ++
          [ (otherModMasks ++ "M-" ++ [key], action tag)
          | (tag, key)  <- zip myWorkspaces "123456789"
          , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
          , ("S-", windows . W.shift)]]

	  where
          	scratchPad = scratchpadSpawnActionTerminal myBlueTerminal

-- Mouse bindings

--myMouseKeys = [ "M-S" button1, sendMessage (IncreaseUp 1)
--((mod4Mask .|. shiftMask, button1), sendMessage (IncreaseUp 1))
 --]

-- `additionalMouseBindings`
-- [ -- get the middle button to switch views
--  ((0, 4), const $ spawn "xdotool key super+Down")
-- , ((0, button7), \w -> moveTo Prev)
-- ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
	[ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)) -- Set the window to floating mode and move by dragging
	, ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))                      -- Raise the window to the top of the stack
	, ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))                        -- Set the window to floating mode and resize by dragging
	, ((modMask, button4), (\_ -> prevWS))                                                -- Switch to previous workspace
	, ((modMask, button5), (\_ -> nextWS))                                                -- Switch to next workspace
	, (((modMask .|. shiftMask), button4), (\_ -> shiftToPrev))                           -- Send client to previous workspace
	, (((modMask .|. shiftMask), button5), (\_ -> shiftToNext))                           -- Send client to previous workspace
	]

-- Urxvtc options
mySmallBlueTerminal = "urxvtc -bg '#000033' -title 'floatingurxvtc' -fn 'xft:SauceCodePro Nerd Font Mono:size=12'"
myBlueTerminal = "urxvtc -bg '#000033' -fn 'xft:SauceCodePro Nerd Font Mono:size=12'"
myTerminal = "urxvtc"

-- Put it all together
main = xmonad $ ewmh defaultConfig
         { modMask = mod4Mask
	 , startupHook = setWMName "LG3D"
         , terminal = myTerminal
         , borderWidth = 4
         , normalBorderColor  = "#800000"-- "#1a1a1a"
         , focusedBorderColor = "#ff0000" --"#ff3300"
         , layoutHook = spacing 3 $ toggleLayouts (noBorders Full) $ myLayout
         , workspaces = myWorkspaces
	 , manageHook = myManageHook <+> manageScratchPad
	 , mouseBindings = myMouseBindings
         }
         `additionalKeysP` myKeys
	 -- `additionalMouseBindings` myMouseKeys
