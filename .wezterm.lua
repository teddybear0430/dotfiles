local wezterm = require 'wezterm';

-- ウィンドウが最初に表示されてから1秒後に開始され、1秒に1回トリガーされるイベントを定義
-- 年月日と時間・バッテリーの残量をステータスバーに表示する
wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Setting date
  local date = wezterm.strftime('📆 %Y-%m-%d (%a) ⏰ %H:%M:%S');
  table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('🔋%.0f%%', b.state_of_charge * 100))
  end

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}

  -- Translate a cell into elements
  function push(text)
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell)
  end

  window:set_right_status(wezterm.format(elements))
end)

local base_colors = {
  black = '#1c1c1c',
  yellow = '#ffe64d'
}

local colors = {
  background = base_colors['black'],
  cursor_bg = base_colors['yellow'],
  split = '#6fc3df',
  ansi = {
    -- black
    '#0c141f',
    -- red
    '#df740c',
    -- green
    '#00c200',
    -- yellow
    '#f8e420',
    -- blue
    '#6c72d8',
    -- magenta
    '#af0087',
    -- cyan
    '#6fc3df',
    -- white
    '#e6ffff'
  },
  brights = {
    '#676767',
    '#ff6d67',
    '#5ff967',
    '#fefb67',
    '#6871ff',
    '#ff76ff',
    '#5ffdff',
    '#feffff'
  },
  tab_bar = {
    background = base_colors['black'],
    -- The active tab is the one that has focus in the window
    active_tab = {
      -- activeなタブの背景色を変更する
      bg_color = 'aliceblue',
      fg_color = base_colors['black'],
    },
  },
}

-- キーバインドの設定

-- macの場合は以下のようになる
-- CTRL・・・CMD
-- ALT・・・OPTION
local act = wezterm.action;

-- leader keyを CTRL + qにマッピング
local leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 1000 };

local keys = {
  -- CMD + cでタブを新規作成
  { key = 'c', mods = 'LEADER', action = act({ SpawnTab = 'CurrentPaneDomain' })},
  -- CMD + xでタブを閉じる
  { key = 'x', mods = 'LEADER', action = act({ CloseCurrentTab = { confirm = false } })},
  -- CTRL + q + numberでタブの切り替え
  { key = '1', mods = 'LEADER', action = act({ ActivateTab = 0 })},
  { key = '2', mods = 'LEADER', action = act({ ActivateTab = 1 })},
  { key = '3', mods = 'LEADER', action = act({ ActivateTab = 2 })},
  { key = '4', mods = 'LEADER', action = act({ ActivateTab = 3 })},
  { key = '5', mods = 'LEADER', action = act({ ActivateTab = 4 })},
  { key = '6', mods = 'LEADER', action = act({ ActivateTab = 5 })},
  { key = '7', mods = 'LEADER', action = act({ ActivateTab = 6 })},
  { key = '8', mods = 'LEADER', action = act({ ActivateTab = 7 })},
  { key = '9', mods = 'LEADER', action = act({ ActivateTab = 8 })},
  -- PANEを水平方向に開く
  { key = '-', mods = 'LEADER', action = act({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
  -- PANEを縦方向に開く
	{ key = '|', mods = 'LEADER', action = act({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
  -- hjklでPANEを移動する
  { key = 'h', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Left' }) },
  { key = 'l', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Right' }) },
  { key = 'k', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Up' }) },
  { key = 'j', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Down' }) },
  -- PANEを閉じる
  { key = 'x', mods = 'CTRL', action = act({ CloseCurrentPane = { confirm = false } }) },
  -- ALT + hjklでペインの幅を調整する
  { key = 'h', mods = 'ALT', action = act({ AdjustPaneSize = { 'Left', 5 } }) },
  { key = 'l', mods = 'ALT', action = act({ AdjustPaneSize = { 'Right', 5 } }) },
  { key = 'k', mods = 'ALT', action = act({ AdjustPaneSize = { 'Up', 5 } }) },
  { key = 'j', mods = 'ALT', action = act({ AdjustPaneSize = { 'Down', 5 } }) },
  -- QuickSelect・・・画面に表示されている文字をクイックにコピペできる機能
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
}

return {
  color_scheme = 'PaperColorDark (Gogh)',
  colors = colors,
  use_fancy_tab_bar = false,
  font_size = 16.5,
  font = wezterm.font('Ricty Diminished', { weight='Bold' }),
  line_height = 1.2,
  leader = leader,
  keys = keys
}