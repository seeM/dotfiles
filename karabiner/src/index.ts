import {
  ifApp,
  ifDevice,
  map,
  NumberKeyValue,
  rule,
  writeToProfile,
} from 'karabiner.ts'

const emacsDisabledApps = ifApp({
  bundle_identifiers: [
    '^com\\.googlecode\\.iterm2$',
    '^io\\.alacritty$',
    '^org\\.alacritty$',
    '^org\\.gnu\\.Emacs$',
    '^com\\.microsoft\\.VSCode$',
  ]
});

const terminalApps = ifApp({
  bundle_identifiers: [
    '^com\\.googlecode\\.iterm2$',
    '^io\\.alacritty$',
    '^org\\.alacritty$',
  ]
});

const glove = ifDevice({ vendor_id: 5824, product_id: 10203 })
const wasd = ifDevice({ vendor_id: 1241, product_id: 321 })

writeToProfile('Default', [
  // caps to ctrl (not on glove)
  rule('caps to ctrl').condition(glove.unless()).manipulators([
    map('caps_lock', { optional: '⌘⌥⇧'}).to('<⌃'),
  ]),

  // global emacs keys (not in terminal/emacs apps)
  rule('global emacs keys').condition(emacsDisabledApps.unless()).manipulators([
    map('b', '⌃', '⇧').to('←'),
    map('p', '⌃', '⇧').to('↑'),
    map('n', '⌃', '⇧').to('↓'),
    map('f', '⌃', '⇧').to('→'),
    map('m', '⌃').to('⏎'),
    map('h', '⌃').to('⌫'),
  ]),

  // fn arrow key shortcuts
  rule('fn arrow key shortcuts').manipulators([
    map('j', ['fn', '⇧']).to('←', 'fn'),
    map('l', ['fn', '⇧']).to('→', 'fn'),
    map('h', 'fn').to('←'),
    map('k', 'fn').to('↑'),
    map('j', 'fn').to('↓'),
    map('l', 'fn').to('→'),
  ]),

  // fn media key shortcuts
  rule('fn media key shortcuts').manipulators([
    map('w', 'fn').to('play_or_pause'),
    map('q', 'fn').to('rewind'),
    map('e', 'fn').to('fastforward'),
  ]),

  // ctrl-[ to esc
  rule('ctrl-[ to esc').manipulators([
    map('open_bracket', '⌃').to('⎋'),
  ]),

  // ctrl-m to enter
  rule('ctrl-m to enter').manipulators([
    map('m', '⌃').to('⏎'),
  ]),

  // meta key (option as meta, not in terminal/emacs apps)
  // Note: original .edn had typo ":!emacs-disabed" — fixed here
  rule('meta key').condition(emacsDisabledApps.unless()).manipulators([
    map('b', '⌥', '⇧').to('←', '⌥'),
    map('b', 'right_control').to('←', '⌥'),
    map('f', '⌥', '⇧').to('→', '⌥'),
    map('d', '⌥').to('⌦', '⌥'),
    map('h', '⌥').to('⌫', '⌥'),
  ]),

  // wasd keyboard esc to tilde
  rule('wasd keyboard esc to tilde').condition(wasd).manipulators([
    map('escape').to('non_us_backslash'),
    map('grave_accent_and_tilde', ['⌃', '⇧']).to('non_us_backslash', ['⌃', '⇧']),
    map('grave_accent_and_tilde').to('⎋'),
  ]),

  // cmd -> cmd+tab (not on glove)
  rule('cmd -> cmd+tab').condition(glove.unless()).manipulators([
    map('left_command').to('left_command').toIfAlone('tab', '⌘').parameters({'basic.to_if_alone_timeout_milliseconds': 200}),
    map('right_command').to('right_command').toIfAlone('tab', '⌘').parameters({'basic.to_if_alone_timeout_milliseconds': 200}),
  ]),

  // emacs keys in dbeaver/onenote
  rule('emacs keys in dbeaver').condition(
    ifApp({
      bundle_identifiers: [
        '^org\\.jkiss\\.dbeaver\\.core\\.product$',
        '^com\\.microsoft\\.onenote\\.mac',
      ]
    }),
  ).manipulators([
    map('a', '⌃', '⇧').to('←', '⌘'),
    map('e', '⌃', '⇧').to('→', '⌘'),
    map('k', '⌃').to('→', ['⌘', '⇧']).to('x', '⌘'),
    map('y', '⌃').to('v', '⌘'),
  ]),

  // iterm/alacritty tmux shortcuts
  rule('iterm tmux').condition(terminalApps).manipulators([
    // Tabs
    map('t', '⌘').to('t', '⌃').to('c'),
    map('t', 'right_command').to('t', '⌃').to('c'),
    map('d', ['⌘', '⇧']).to('t', '⌃').to('s'),
    map('d', ['right_command', 'right_shift']).to('t', '⌃').to('s'),
    map('d', '⌘').to('t', '⌃').to('v'),
    map('d', 'right_command').to('t', '⌃').to('v'),
    map('open_bracket', ['⌘', '⇧']).to('t', '⌃').to('p'),
    map('close_bracket', ['⌘', '⇧']).to('t', '⌃').to('n'),
    // Tab numbers
    map(1 as NumberKeyValue, '⌘').to('t', '⌃').to(1 as NumberKeyValue),
    map(1 as NumberKeyValue, 'right_command').to('t', '⌃').to(1 as NumberKeyValue),
    map(2 as NumberKeyValue, '⌘').to('t', '⌃').to(2 as NumberKeyValue),
    map(2 as NumberKeyValue, 'right_command').to('t', '⌃').to(2 as NumberKeyValue),
    map(3 as NumberKeyValue, '⌘').to('t', '⌃').to(3 as NumberKeyValue),
    map(3 as NumberKeyValue, 'right_command').to('t', '⌃').to(3 as NumberKeyValue),
    map(4 as NumberKeyValue, '⌘').to('t', '⌃').to(4 as NumberKeyValue),
    map(4 as NumberKeyValue, 'right_command').to('t', '⌃').to(4 as NumberKeyValue),
    map(5 as NumberKeyValue, '⌘').to('t', '⌃').to(5 as NumberKeyValue),
    map(5 as NumberKeyValue, 'right_command').to('t', '⌃').to(5 as NumberKeyValue),
    map(6 as NumberKeyValue, '⌘').to('t', '⌃').to(6 as NumberKeyValue),
    map(6 as NumberKeyValue, 'right_command').to('t', '⌃').to(6 as NumberKeyValue),
    map(7 as NumberKeyValue, '⌘').to('t', '⌃').to(7 as NumberKeyValue),
    map(7 as NumberKeyValue, 'right_command').to('t', '⌃').to(7 as NumberKeyValue),
    map(8 as NumberKeyValue, '⌘').to('t', '⌃').to(8 as NumberKeyValue),
    map(8 as NumberKeyValue, 'right_command').to('t', '⌃').to(8 as NumberKeyValue),
    map(9 as NumberKeyValue, '⌘').to('t', '⌃').to(9 as NumberKeyValue),
    map(9 as NumberKeyValue, 'right_command').to('t', '⌃').to(9 as NumberKeyValue),
    map(0 as NumberKeyValue, '⌘').to('t', '⌃').to(0 as NumberKeyValue),
    map(0 as NumberKeyValue, 'right_command').to('t', '⌃').to(0 as NumberKeyValue),
    // Panes
    map('l', '⌘').to('t', '⌃').to('l'),
    map('h', '⌘').to('t', '⌃').to('h'),
    map('k', '⌘').to('t', '⌃').to('k'),
    map('j', '⌘').to('t', '⌃').to('j'),
  ]),

  // glove caps -> fn
  rule('glove caps -> fn').condition(glove).manipulators([
    map('caps_lock', { optional: '<⌘⌥⌃⇧'}).to('fn'),
  ]),
])
