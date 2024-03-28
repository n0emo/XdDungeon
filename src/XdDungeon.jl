module XdDungeon

include("Game.jl")

import .Raylib:
    Vector2,
    Color,
    Camera2D,
    init_window,
    draw_rectangle_v,
    set_target_fps,
    KeyboardKey,
    is_key_pressed,
    clear_background,
    begin_drawing,
    begin_mode_2d,
    end_drawing,
    end_mode_2d,
    window_should_close,
    close_window


const size = 50
const size_v = Vector2(size, size)

const width = 800
const height = 600

const map = """
            ###.###
            #.....#
            .......@.
            #.....#
            #####.#
            """

const bg_color = Color(40, 40, 40, 255)
const player_color = Color(240, 40, 40, 255)
const tiles = Dict([
    (NOTHING, Tile(bg_color, false))
    (FLOOR, Tile(Color(18, 18, 30, 255), false))
    (WALL, Tile(Color(70, 70, 140, 255), false))
])

function move_player(game::Game)
    new_x = game.player.position.x
    new_y = game.player.position.y

    if is_key_pressed(KeyboardKey.S)
        new_y += 1
    end
    if is_key_pressed(KeyboardKey.W)
        new_y -= 1
    end
    if is_key_pressed(KeyboardKey.D)
        new_x += 1
    end
    if is_key_pressed(KeyboardKey.A)
        new_x -= 1
    end

    if 1 <= new_y <= length(game.map) &&
       1 <= new_x <= length(game.map[Int(new_y)]) &&
       !tiles[game.map[Int(new_y)][Int(new_x)]].solid
        game.player.position = Vector2(new_x, new_y)
    end
end

function lerp(
    a::Vector2,
    b::Vector2,
    ratio::Float64)::Vector2
    a * (1 - ratio) + b * ratio
end

function eerp(
    a::Vector2,
    b::Vector2,
    ratio::Float64)::Vector2
    a = a^(1 - ratio)
    b = b^ratio
    Vector2(a.x * b.x, a.y * b.y)
end

function draw(game::Game, camera::Camera2D)
    clear_background(bg_color)
    begin_mode_2d(camera)

    for (i, row) = enumerate(game.map)
        for (j, col) = enumerate(row)
            pos = Vector2(j, i) * size
            draw_rectangle_v(pos, size_v, tiles[col].color)
        end
    end

    draw_rectangle_v(game.player.position * size, size_v, player_color)

    end_mode_2d()
end

function main()
    game = generate_game()

    init_window(800, 600, "XD Dungeon")
    set_target_fps(60)

    camera = Camera2D(
        (Vector2(width, height) - size) / 2,
        game.player.position * size, 0, 1)

    while !window_should_close()
        move_player(game)

        camera = Camera2D(
            (Vector2(width, height) - size) / 2,
            eerp(camera.target, game.player.position * size, 0.05),
            0, 1)

        begin_drawing()
        draw(game, camera)
        end_drawing()
    end

    close_window()
end

main()

end # module XdDungeon

