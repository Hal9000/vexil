use Mix.Config

config :vexil, :bot,
  count:      [defender: 3, fighter: 6, scout: 8],
  start_edge: [defender: 5, fighter: 6, scout: 8..9],
  stats: [
    defender: [attack: 4, defend: 6, move: 2, range: 2, see: 2],
    fighter:  [attack: 6, defend: 6, move: 4, range: 4, see: 2],
    scout:    [attack: 2, defend: 3, move: 5, range: 1, see: 2]
  ]

config :vexil, :battleground,
  flag_max_edge: 4,
  neutral_extra_space: 5

config :vexil, :teams,
  coral: "Red monkeys",
  mediumblue: "Blue pigs",
  greenyellow: "Yellow Submarine",
  orange: "Power Oranges"
