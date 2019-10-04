import XMonad
import XMonad.Util.EZConfig        -- append key/mouse bindings
import qualified XMonad.StackSet as W        -- for overriding default greedyview setting on dual monitor
import XMonad.Actions.DwmPromote   -- swap master like dwm
import XMonad.Actions.CycleWindows -- classic alt-tab
import XMonad.Actions.CycleWS      -- cycle workspaces
import XMonad.Hooks.EwmhDesktops   -- for rofi/wmctrl
import XMonad.Layout.ResizableTile -- for resizeable tall layout
import XMonad.Layout.MouseResizableTile -- for mouse control
import XMonad.Layout.ThreeColumns  -- for three column layout
import XMonad.Layout.Grid          -- for additional grid layout
import XMonad.Layout.NoBorders     -- for fullscreen without borders
import XMonad.Layout.Fullscreen    -- fullscreen mode


myWorkspaces = [
		  "0: Sys"
		, "1: WWW"
		, "2: Devel"
		, "3: FM"
		, "4: Image"
		, "5: Util1"
		, "6: Util2"
		, "7: Misc1"
		, "8: Misc2"
		, "9: Hide"
	       ]

-- startupWorkspace = "2: Foo"

myLayout = smartBorders (ResizableTall 1 (3/100) (1/2) []
			||| Mirror (ResizableTall 1 (3/100) (3/4) [])
			||| Grid
			||| ThreeColMid 1 (3/100) (1/2)
			||| noBorders Full
			||| mouseResizableTile)

-- Non-numeric num pad keys, sorted by number 
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
             , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
             , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
             , xK_KP_Insert]                            -- 0

modm = mod4Mask

myKeys = [ ("M1-<Tab>"   , cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab ) -- classic alt-tab behaviour
         , ("M-<Return>" , dwmpromote                                  ) -- swap the focused window and the master window
         , ("M-<Tab>"    , toggleWS                                    ) -- toggle last workspace (super-tab)
         , ("M-<Right>"  , nextWS                                      ) -- go to next workspace
         , ("M-<Left>"   , prevWS                                      ) -- go to prev workspace
         , ("M-S-<Right>", shiftToNext                                 ) -- move client to next workspace
         , ("M-S-<Left>" , shiftToPrev                                 ) -- move client to prev workspace
         , ("M-c"        , spawn "kcalc"                               ) -- calc
      	 , ("M-<F1>"     , spawn "start-via.sh"                        ) -- via/rofi mulitfunctional launcher
         , ("M-<F2>"     , spawn "rofi -show run"                      ) -- rofi app launcher
         , ("M-<F3>"     , spawn "rofi -show window"                   ) -- rofi window switch
         , ("M-<F4>"     , spawn "cheatsheet sgl"                      ) -- cheatsheet app
         , ("M-<F5>"     , spawn "nvim-qt /home/aren/.xmonad/xmonad.hs") -- edit config
         , ("M-r"        , spawn "xmonad --restart"                    ) -- restart xmonad w/o recompiling
         , ("M-b"        , spawn "falkon"                              ) -- launch browser
	-- , ("M-h"        , spawn "thunderbird"                         ) -- launch thunderbird
      	 , ("M-k"        , spawn "keepassxc"                           ) -- launch keepassxc
         , ("M-e"        , spawn "nvim-qt"                             ) -- launch nvim editor
         , ("M-s"        , spawn "spectacle"                           ) -- launch system top
         , ("M-f"        , spawn "xfe"                                 ) -- launch xfe file manager
         , ("M-m"        , spawn "mindforger"                          ) -- launch mindforger 
         , ("M-w"        , spawn "taskcoach.py"                        ) -- launch task coach
         , ("M-i"        , spawn "telegram"                            ) -- launch telegram IM
	 , ("M-v"        , spawn "nvim-qt -- -u ~/.SpaceVim/vimrc"     ) -- launch SpaceVim
         , ("M-z"        , prevScreen                                  ) -- switch screen
         -- , ("M-x"        , nextScreen                               ) -- single screen switching key enough
	 , ("M-g"        , moveTo Next HiddenNonEmptyWS                ) 
         ]
         ++
          [ (otherModMasks ++ "M-" ++ [key], action tag)
          | (tag, key)  <- zip myWorkspaces "123456789"
          , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
          , ("S-", windows . W.shift)]] 
-- ++
--       [ (otherModMasks ++ "M-" ++ [key], action tag)
  --    | (tag, key)  <- zip myWorkspaces "<KP_End><KP_Down><KP_Page_Down><KP_Left><KP_Begin><KP_Right><KP_Home><KP_Up><KP_Page_Up><KP_Insert>" 
    --  , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
      --  , ("S-", windows . W.shift)]
      --  ]
--   [((m .|. modm, k), windows $ f i)
--	    | (i, k) <- zip myWorkspaces numPadKeys
--	    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
	    
       --  ++
       --  [((m .|. mod4Mask, k), windows $ f i) -- Replace 'mod1Mask' with your mod key of choice.
        --      | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
         --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
         --
         --
         --


main = xmonad $ ewmh defaultConfig
         { modMask = mod4Mask 
         , terminal = "urxvt" -- "xterm -rightbar -sb -fn 10x20" 
         , borderWidth = 3 
         , normalBorderColor  = "#802000"
         , focusedBorderColor = "#ff3300"
         , layoutHook = myLayout
         , workspaces = myWorkspaces
         }
         `additionalKeysP` myKeys
