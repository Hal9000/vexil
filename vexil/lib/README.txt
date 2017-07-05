(This README is taken from a chapter of a book in progress)

== Vexil and its Heritage

This is a simple "capture the flag" type of game. I call it Vexil (a name 
derived from the Latin _vexillum for "flag").

Vexil is _not a board game, although glancing at it might make you think so.
It actually derives from *([discuss Core Wars and Darwin]).

In a board game like chess or checkers, there are two opponents, each with 
absolute knowledge of the entire board. But in Vexil, the opponents are more
like _teams (labeled "red" and "blue"). Each player on a team is intended to 
act autonomously, with no global knowledge of the grid and no single point of
control.

So a good analogy is the "battling bots" type of game which we've seen many times
in the past. I'm sure you can see the direction this is going. Each player or 
piece will (ultimately) be controlled by a single process; these processes will
collaborate to defeat those on the other team. As such, it will finally be a 
battle of algorithms, where coders write their best logic for the bots and then
turn them loose on the grid. The "referee" process will manage communication, 
enforce the rules, prevent (easy) cheating, and declare a winner.

So on to the details. The Vexil grid is 21 by 21 for a total of 441 cells.
The Red team originates in the lower left portion, diagonally across from the
Blue team on the upper right.

Each team views the grid in its own coordinate system. The _x and _y values 
can vary from 1 to 21. For example, the cell that the Red team calls `(3,5)
will be viewed as `(19,17) from the Blue side.

Each team has a "flag" that is randomly placed by the referee within four cells
of the corner (i.e., somewhere in that 4-by-4 area). We'll call this zone 1.
Besides the flag, nothing starts out in this area,

There are three kinds of pieces or players. Each kind is characterized by its
abilities in several areas of behavior:

.list!
It can _see a square sub-grid centered on itself and "know" what is in each of
  the nearby occupied cells (friend or for or flag);
It can _move a certain number of cells per turn, any combination of horizontal
  and vertical moves;
It can _defend itself by withstanding an attack up to a certain number of points
  of damage;
It can _attack and inflict damage points on an opposing piece;
It can attack within a limited _range (true distance between cells),
.end

The following rules apply. Some are dictated by common sense, while others are
more or less arbitrary.

.list!
No cell can contain more than one piece at a time; possible collisions will be
  resolved randomly.
Every piece "knows" where its team's flag is.
No piece knows the enemy flag's location until it is in visual range.
A piece cannot "see" through other pieces regardless of range.
A piece can always see farther than it can move.
A piece always has an attack range less than its range of motion.
Pieces may communicate with their own team members (by "radio") regardless of 
  distance.
Mutual attacks will be resolved randomly.
When a piece receives damage, it never recuperates; when its constitution (or
  "hit points") reaches zero, it dies and is removed from the grid.
Pieces never run out of "ammunition" (ability to attack).
Pieces may not attack their own team.
When a piece moves onto the cell containing the enemy's flag, the game is over.
A piece may of course not capture its own flag.
.end

So as I said, there are three kinds of pieces. The _defender cannot see or move
very far, but it can attack and it is difficult to kill. The _scout can see far
and move quickly, but cannot attack (or withstand attacks) very well. The
_fighter is faster than the defender but slower than the scout; it is tougher
than the scout, but not so tough as the defender; and it is the best attacker
of all. This information is summarized in this table:

.missing FIXME

.table2 Table of piece abilities
         :: Can move :: Can see :: Defending :: Attacking :: Range
Defender :: 2 :: 3 :: 6 :: 4 :: 2
Fighter  :: 4 :: 6 :: 6 :: 6 :: 4
Scout    :: 5 :: 8 :: 3 :: 2 :: 1
.end

For those of us who are visually oriented, here is a diagram of the grid:

.missing Diagram of grid and zones
. timest 2 hrs

Zone 2 is an L-shaped area consisting of the 5-by-5 area nearest the corner,
_minus the cells in zone 1. Here the referee randomly places three defenders.

Zones 3 and 4 are also L-shaped areas. The referee randomly populates zone 3
with six fighters and zone 4 with six scouts.


.sec A First Approximation in Ruby

I don't usually include really large, complete pieces of code in a book. In this
book, I am making an exception.

For a little more digestibility, this game is split into multiple files. Let's 
look first at a "roadmap" of these files and the classes and methods they define.

.mono
  # File: examples/vexil0/grid.rb          
    class Grid                          # 
      def initialize                    # 
      def [](team, x, y)                # 
      def []=(team, x, y, obj)          # 
      def coordinates(team, x, y)       # 

  # File: examples/vexil0/ misc.rb                             
    class String                        # 
      def red                           # 
      def blue                          # 

  # File: examples/vexil0/referee.rb                         
    class Referee                       # 
      def initialize                    # 
      def show_cell(xx, yy)             # 
      def record(line)                  # 
      def display                       # 
      def [](team, x, y)                # 
      def setup                         # 
      def turn                          # 
      def pause                         # 
      def move(team, x0, y0, x1, y1)    # 
      def attack(qty, team, x, y)       # 
      def place(team, kind, x, y)       # 
      def over!                         # 
      def over?                         # 

  # File: examples/vexil0/pieces.rb                          

    class Bot                           # 
      def initialize(team, data, x, y)  # 
      def to_s                          # 
      def who                           # 
      def move(dx, dy)                  # 
      def move!(dx, dy)                 # 
      def where                         # 
      def enemy?(piece)                 # 
      def within(n)                     # 
      def can_see                       # 
      def can_attack                    # 
      def turn                          # 
      def attack(qty, team, x, y)       # 

    class Defender < Bot                # 
      def initialize(team, x, y)        # 
      def turn                          # 

    class Fighter < Bot                 # 
      def initialize(team, x, y)        # 
      def turn                          # 

    class Scout < Bot                   # 
      def initialize(team, x, y)        # 
      def turn                          # 

    class Flag < Bot                    # 
      def initialize(team, x, y)        # 
.end

The `Grid class handles the logic of the "board" or "field" on which the pieces 
move. Coordinates are in _x-y form and are relative to each team's corner. The
"absolute" coordinates are the red one (origin lower left). The coordinates are
1-based (ranging from 1 to 21).

.ruby examples/vexil0/grid.rb

The `Referee class handles all the details of the game itself in an impartial 
way. For example, when a piece attacks another, the `attack method in `Referee
manages it, recording damage and removing dead pieces from the grid.

The `display method shows the grid and ongoing history of the game on the
terminal; it currently works in a very "dumb" way by clearing the screen and
redrawing the contents. The pieces are colored via ANSI terninal codes; refer to 
the reopened `String class with methods `red and `blue added.

To be continued...

