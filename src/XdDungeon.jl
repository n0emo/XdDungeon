module XdDungeon

include("Raylib.jl")


const bg_color = Raylib.Color(40, 40, 40, 255)
const rect_color = Raylib.Color(18, 18, 30, 255)
const text_color = Raylib.Color(40, 100, 80, 255)


function main()
    rect_x = 100
    rect_y = 100

    Raylib.init_window(800, 600, "XD Dungeon")
    Raylib.set_target_fps(60)

    while !Raylib.window_should_close()
        if Raylib.is_key_down(Raylib.KeyboardKey.S)
            rect_y += 1
        end
        if Raylib.is_key_down(Raylib.KeyboardKey.W)
            rect_y -= 1
        end

        Raylib.begin_drawing()

        Raylib.clear_background(bg_color)
        Raylib.draw_rectangle(rect_x, rect_y, 50, 50, rect_color)
        Raylib.draw_text("Hello world", 200, 200, 24, text_color)

        Raylib.end_drawing()
    end

    Raylib.close_window()
end

main()

end # module XdDungeon

