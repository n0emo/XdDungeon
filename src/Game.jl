include("Raylib.jl")
using .Raylib: Vector2, Rectangle

@enum TileType NOTHING FLOOR WALL

@enum Direction UP DOWN LEFT RIGHT

mutable struct Player
    position::Vector2

    Player() = new(Vector2(0, 0))
    Player(x, y) = new(Vector2(x, y))
end

struct Tile
    color::Raylib.Color
    solid::Bool
end

mutable struct Game
    player::Player
    map::Vector{Vector{TileType}}

    Game() = new(Player(), Vector{Vector{Int}}())
end

struct Room
    rect::Rectangle
end

random_direction()::Direction = rand([UP, DOWN, LEFT, RIGHT])

function generate_game()::Game
    game = Game()

    bound_left::Int64 = 1
    bound_up::Int64 = 1
    bound_right::Int64 = 1
    bound_down::Int64 = 1

    rooms = Vector{Room}()

    for _ = 1:10
        width = rand(8:15)
        height = rand(8:15)
        choice = random_direction()
        x = rand(3:6)
        y = rand(3:6)
        if choice == DOWN
            y += bound_down + 3
        elseif choice == UP
            y -= height - bound_up + 3
        elseif choice == LEFT
            x -= width - bound_left + 3
        elseif choice == RIGHT
            x += bound_right + 3
        end

        room = Room(Rectangle(x, y, width, height))
        println(room)

        push!(rooms, room)
        if x < bound_left
            bound_left = x
        elseif x + room.rect.width > bound_right
            bound_right = x + room.rect.width
        end

        if y < bound_up
            bound_up = y
        elseif y + room.rect.height > bound_down
            bound_down = y + room.rect.height
        end
    end


    offset_x = 1
    if bound_left < 1
        offset_x -= bound_left
    end
    offset_y = 1
    if bound_up < 1
        offset_y -= bound_up
    end

    println("Offset X: $offset_x")
    println("Offset Y: $offset_y")

    game.map = Vector{Vector{TileType}}()
    resize!(game.map, bound_down + offset_y)
    for i = eachindex(game.map)
        game.map[i] = Vector{TileType}()
        row = game.map[i]
        resize!(row, bound_right + offset_x)
        for j = eachindex(row)
            row[j] = NOTHING
        end
    end


    for room = rooms
        r = room.rect
        x = Int(r.x) + offset_x
        y = Int(r.y) + offset_y
        width = Int(r.width)
        height = Int(r.height)

        for i = x:x+width
            game.map[y][i] = WALL
            game.map[y+height][i] = WALL
        end

        for i = y:y+height
            game.map[i][x] = WALL
            game.map[i][x+width] = WALL
        end

        for i = y+1:y+height-1
            for j = x+1:x+width-1
                game.map[i][j] = FLOOR
            end
        end
    end

    root = rooms[1]
    game.player = Player(
        floor(root.rect.width / 2) + offset_x,
        floor(root.rect.height / 2) + offset_y)

    game
end
