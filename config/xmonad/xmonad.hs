import XMonad
import XMonad.Util.EZConfig        -- append key/mouse bindings
import XMonad.Actions.DwmPromote   -- swap master like dwm
import XMonad.Actions.CycleWindows -- classic alt-tab
import XMonad.Actions.CycleWS      -- cycle workspaces
import XMonad.Hooks.EwmhDesktops   -- for rofi/wmctrl

main = xmonad $ ewmh defaultConfig
         { modMask = mod4Mask 
         , terminal = "xterm -rightbar -sb -fn 10x20" 
	 , borderWidth = 4 
         , normalBorderColor  = "#29a329"
         , focusedBorderColor = "#ff3300"
         }
	`additionalKeysP` myKeys


myKeys = [ ("M1-<Tab>"   , cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab ) -- classic alt-tab behaviour
         , ("M-<Return>" , dwmpromote                                  ) -- swap the focused window and the master window
         , ("M-<Tab>"    , toggleWS                                    ) -- toggle last workspace (super-tab)
         , ("M-<Right>"  , nextWS                                      ) -- go to next workspace
         , ("M-<Left>"   , prevWS                                      ) -- go to prev workspace
         , ("M-S-<Right>", shiftToNext                                 ) -- move client to next workspace
         , ("M-S-<Left>" , shiftToPrev                                 ) -- move client to prev workspace
         , ("M-c"        , spawn "kcalc"                               ) -- calc
         , ("M-<F2>"     , spawn "PATH=$PATH:/home/aren/Documents/scripts rofi -show run -theme Monokai"       ) -- rofi app launcher
         , ("M-<F3>"     , spawn "rofi -show window -theme Monokai"    ) -- rofi window switch
         , ("M-r"        , spawn "xmonad --restart"                    ) -- restart xmonad w/o recompiling
         , ("M-b"        , spawn "falkon"                              ) -- launch browser
         , ("M-s"        , spawn "xterm -fn 10x20 -e top"              ) -- launch system top
	 , ("M-f"        , spawn "xfe"                                 ) -- launch xfe file manager
         , ("M-m"        , spawn "mindforger"                          ) -- launch mindforger 
         ]

