module XdDungeon

include("Raylib.jl")

mutable struct Player
    position::Raylib.Vector2

    Player() = new(Raylib.Vector2(0, 0))
    Player(x, y) = new(Raylib.Vector2(x, y))
end

struct Tile
    color::Raylib.Color
    solid::Bool
end

mutable struct Game
    player::Player
    map::Vector{Vector{Int}}

    Game() = new(Player(), Vector{Vector{Int}}())
end

const NOTHING::Int = 0
const FLOOR::Int = 1
const WALL::Int = 2

const size = 50
const size_v = Raylib.Vector2(size, size)

const width = 800
const height = 600

const map = """
            ###.###
            #.....#
            .......@.
            #.....#
            #####.#
            """

const bg_color = Raylib.Color(40, 40, 40, 255)
const player_color = Raylib.Color(240, 40, 40, 255)
const tiles = Dict([
    (NOTHING, Tile(bg_color, true))
    (FLOOR, Tile(Raylib.Color(18, 18, 30, 255), false))
    (WALL, Tile(Raylib.Color(70, 70, 140, 255), true))
])

function parse_game(str::String)::Game
    game::Game = Game()
    lines::Vector{String} = split(str, "\n")
    resize!(game.map, length(lines))

    for (i, line) = enumerate(lines)
        row = Vector{Int}()
        resize!(row, length(line))
        for (j, c) = enumerate(line)
            if c == '#'
                row[j] = WALL
            elseif c == '.'
                row[j] = FLOOR
            elseif c == '@'
                game.player = Player(j, i)
                row[j] = FLOOR
            else
                row[j] = NOTHING
            end
        end
        game.map[i] = row
    end

    game
end

function move_player(game::Game)
    new_x = game.player.position.x
    new_y = game.player.position.y

    if Raylib.is_key_pressed(Raylib.KeyboardKey.S)
        new_y += 1
    end
    if Raylib.is_key_pressed(Raylib.KeyboardKey.W)
        new_y -= 1
    end
    if Raylib.is_key_pressed(Raylib.KeyboardKey.D)
        new_x += 1
    end
    if Raylib.is_key_pressed(Raylib.KeyboardKey.A)
        new_x -= 1
    end

    if 1 <= new_y <= length(game.map) &&
       1 <= new_x <= length(game.map[Int(new_y)]) &&
       !tiles[game.map[Int(new_y)][Int(new_x)]].solid
        game.player.position = Raylib.Vector2(new_x, new_y)
    end
end

function lerp(
    a::Raylib.Vector2,
    b::Raylib.Vector2,
    ratio::Float64)::Raylib.Vector2
    a * (1 - ratio) + b * ratio
end

function eerp(
    a::Raylib.Vector2,
    b::Raylib.Vector2,
    ratio::Float64)::Raylib.Vector2
    a = a^(1 - ratio)
    b = b^ratio
    Raylib.Vector2(a.x * b.x, a.y * b.y)
end

function draw(game::Game, camera::Raylib.Camera2D)
    Raylib.clear_background(bg_color)
    Raylib.begin_mode_2d(camera)

    for (i, row) = enumerate(game.map)
        for (j, col) = enumerate(row)
            pos = Raylib.Vector2(j, i) * size
            Raylib.draw_rectangle_v(pos, size_v, tiles[col].color)
        end
    end

    Raylib.draw_rectangle_v(game.player.position * size, size_v, player_color)

    Raylib.end_mode_2d()
end

function main()
    game = parse_game(map)

    Raylib.init_window(800, 600, "XD Dungeon")
    Raylib.set_target_fps(60)

    camera = Raylib.Camera2D(
        (Raylib.Vector2(width, height) - size) / 2,
        game.player.position * size, 0, 1)

    while !Raylib.window_should_close()
        move_player(game)

        camera = Raylib.Camera2D(
            (Raylib.Vector2(width, height) - size) / 2,
            eerp(camera.target, game.player.position * size, 0.05),
            0, 1)

        Raylib.begin_drawing()
        draw(game, camera)
        Raylib.end_drawing()
    end

    Raylib.close_window()
end

main()

end # module XdDungeon

