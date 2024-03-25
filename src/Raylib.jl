module Raylib

const raylib = "libraylib.so"

"Vector2, 2 components"
mutable struct Vector2
    x::Cfloat
    y::Cfloat
end

"Color, 4 components, R8G8B8A8 (32bit)"
mutable struct Color
    r::Cuchar
    g::Cuchar
    b::Cuchar
    a::Cuchar
end

"Initialize window and OpenGL context"
function init_window(width::Integer, height::Integer, title::String)
    @ccall raylib.InitWindow(width::Cint, height::Cint, title::Cstring)::Cvoid
end

"Close window and unload OpenGL context"
function close_window()
    @ccall raylib.CloseWindow()::Cvoid
end

"Set background color (framebuffer clear color)"
function clear_background(color::Color)
    @ccall raylib.ClearBackground(color::Color)::Cvoid
end

"Set target FPS (maximum)"
function set_target_fps(fps::Integer)
    @ccall raylib.SetTargetFPS(fps::Cint)::Cvoid
end

"Setup canvas (framebuffer) to start drawing"
function begin_drawing()
    @ccall raylib.BeginDrawing()::Cvoid
end

"End canvas drawing and swap buffers (double buffering)"
function end_drawing()
    @ccall raylib.EndDrawing()::Cvoid
end

"Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)"
function window_should_close()::Bool
    return (@ccall raylib.WindowShouldClose()::Cint) != 0
end

"Draw a color-filled rectangle"
function draw_rectangle(
    pos_x::Integer, pos_y::Integer, width::Integer, height::Integer, color::Color)
    @ccall raylib.DrawRectangle(
        pos_x::Cint, pos_y::Cint, width::Cint, height::Cint, color::Color)::Cvoid
end

"Draw text (using default font) within an image (destination)"
function draw_text(
    text::AbstractString,
    pos_x::Integer,
    pos_y::Integer,
    font_size::Integer,
    color::Color)
    @ccall raylib.DrawText(
        text::Cstring,
        pos_x::Cint,
        pos_y::Cint,
        font_size::Cint,
        color::Color
    )::Cvoid
end
end
