module Raylib

using Base: make_typealias
const raylib = "libraylib.so"

macro dcl(T, args...)
    r = quote end
    for var in args
        push!(r.args, :(local $(esc(var))::$T = zero($T)))
    end
    r
end

"Vector2, 2 components"
struct Vector2
    "Vector x component"
    x::Cfloat
    "Vector y component"
    y::Cfloat
end

"Vector3, 3 components"
struct Vector3
    "Vector x component"
    x::Cfloat
    "Vector y component"
    y::Cfloat
    "Vector z component"
    z::Cfloat
end

"Vector4, 4 components"
struct Vector4
    "Vector x component"
    x::Cfloat
    "Vector y component"
    y::Cfloat
    "Vector z component"
    z::Cfloat
    "Vector w component"
    w::Cfloat
end

"Quaternion, 4 components (Vector4 alias)"
const Quaternion = Vector4

struct Matrix
    "Matrix first row (4 components)"
    m0::Cfloat
    m4::Cfloat
    m8::Cfloat
    m12::Cfloat
    "Matrix second row (4 components)"
    m1::Cfloat
    m5::Cfloat
    m9::Cfloat
    m13::Cfloat
    "Matrix third row (4 components)"
    m2::Cfloat
    m6::Cfloat
    m10::Cfloat
    m14::Cfloat
    "Matrix fourth row (4 components)"
    m3::Cfloat
    m7::Cfloat
    m11::Cfloat
    m15::Cfloat
end

"Color, 4 components, R8G8B8A8 (32bit)"
struct Color
    "Color red value"
    r::Cuchar
    "Color green value"
    g::Cuchar
    "Color blue value"
    b::Cuchar
    "Color alpha value"
    a::Cuchar
end

"Rectangle, 4 components"
struct Rectangle
    "Rectangle top-left corner position x"
    x::Cfloat
    "Rectangle top-left corner position y"
    y::Cfloat
    "Rectangle width"
    width::Cfloat
    "Rectangle height"
    height::Cfloat
end

"Image, pixel data stored in CPU memory (RAM)"
struct Image
    "Image raw data"
    data::Ptr{Cvoid}
    "Image base width"
    width::Cint
    "Image base height"
    height::Cint
    "Mipmap levels, 1 by default"
    mipmaps::Cint
    "Data format (PixelFormat type)"
    format::Cint
end

"Texture, tex data stored in GPU memory (VRAM)"
struct Texture
    "OpenGL texture id"
    id::Cuint
    "Texture base width"
    width::Cint
    "Texture base height"
    height::Cint
    "Mipmap levels, 1 by default"
    mipmaps::Cint
    "Data format (PixelFormat type)"
    format::Cint
end

"Texture2D, same as Texture"
const Texture2D = Texture

"TextureCubemap, same as Texture"
const TextureCubemap = Texture

"RenderTexture, fbo for texture rendering"
struct RenderTexture
    "OpenGL framebuffer object id"
    id::Cuint
    "Color buffer attachment texture"
    texture::Texture
    "Depth buffer attachment texture"
    depth::Texture
end

"RenderTexture2D, same as RenderTexture"
const RenderTexture2D = RenderTexture


"NPatchInfo, n-patch layout info"
struct NPatchInfo
    "Texture source rectangle"
    source::Rectangle
    "Left border offset"
    left::Cint
    "Top border offset"
    top::Cint
    "Right border offset"
    right::Cint
    "Bottom border offset"
    bottom::Cint
    "Layout of the n-patch: 3x3, 1x3 or 3x1"
    layout::Cint
end

"GlyphInfo, font characters glyphs info"
struct GlyphInfo
    "Character value (Unicode)"
    value::Cint
    "Character offset X when drawing"
    offsetX::Cint
    "Character offset Y when drawing"
    offsetY::Cint
    "Character advance position X"
    advanceX::Cint
    "Character image data"
    image::Image
end

"Font, font texture and GlyphInfo array data"
struct Font
    "Base size (default chars height)"
    baseSize::Cint
    "Number of glyph characters"
    glyphCount::Cint
    "Padding around the glyph characters"
    glyphPadding::Cint
    "Texture atlas containing the glyphs"
    texture::Texture2D
    "Rectangles in texture for the glyphs"
    recs::Ptr{Rectangle}
    "Glyphs info data"
    glyphs::Ptr{GlyphInfo}
end

"Camera, defines position/orientation in 3d space"
struct Camera3D
    "Camera position"
    position::Vector3
    "Camera target it looks-at"
    target::Vector3
    "Camera up vector (rotation over its axis)"
    up::Vector3
    "Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic"
    fovy::Cfloat
    "Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC"
    projection::Cint
end

"Camera type fallback, defaults to Camera3D"
const Camera = Camera3D

"Camera2D, defines position/orientation in 2d space"
struct Camera2D
    "Camera offset (displacement from target)"
    offset::Vector2
    "Camera target (rotation and zoom origin)"
    target::Vector2
    "Camera rotation in degrees"
    rotation::Cfloat
    "Camera zoom (scaling), should be 1.0f by default"
    zoom::Cfloat
end

"Mesh, vertex data and vao/vbo"
struct Mesh
    "Number of vertices stored in arrays"
    vertexCount::Cint
    "Number of triangles stored (indexed or not)"
    triangleCount::Cint

    #"Vertex attributes data"
    "Vertex position (XYZ - 3 components per vertex) (shader-location = 0)"
    vertices::Ptr{Cfloat}
    "Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)"
    texcoords::Ptr{Cfloat}
    "Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)"
    texcoords2::Ptr{Cfloat}
    "Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)"
    normals::Ptr{Cfloat}
    "Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)"
    tangents::Ptr{Cfloat}
    "Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)"
    colors::Ptr{Cuchar}
    "Vertex indices (in case vertex data comes indexed)"
    indices::Ptr{Cushort}

    #"Animation vertex data"
    "Animated vertex positions (after bones transformations)"
    animVertices::Ptr{Cfloat}
    "Animated normals (after bones transformations)"
    animNormals::Ptr{Cfloat}
    "Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning)"
    boneIds::Ptr{Cuchar}
    "Vertex bone weight, up to 4 bones influence by vertex (skinning)"
    boneWeights::Ptr{Cfloat}

    "OpenGL identifiers"
    "OpenGL Vertex Array Object id"
    vaoId::Cuint
    "OpenGL Vertex Buffer Objects id (default vertex data)"
    vboId::Ptr{Cuint}
end

"Shader"
struct Shader
    "Shader program id"
    id::Cuint
    "Shader locations array (RL_MAX_SHADER_LOCATIONS)"
    locs::Ptr{Cint}
end

"MaterialMap"
struct MaterialMap
    "Material map texture"
    texture::Texture2D
    "Material map color"
    color::Color
    "Material map value"
    value::Cfloat
end

"Material, includes shader and maps"
struct Material
    "Material shader"
    shader::Shader
    "Material maps array (MAX_MATERIAL_MAPS)"
    maps::Ptr{MaterialMap}
    "Material generic parameters (if required)"
    params::NTuple{4,Cfloat}
end

"Transform, vertex transformation data"
struct Transform
    "Translation"
    translation::Vector3
    "Rotation"
    rotation::Quaternion
    "Scale"
    scale::Vector3
end

"Bone, skeletal animation bone"
struct BoneInfo
    "Bone name"
    name::NTuple{32,Cchar}
    "Bone parent"
    parent::Cint
end

"Model, meshes, materials and animation data"
struct Model
    "Local transform matrix"
    transform::Matrix

    "Number of meshes"
    meshCount::Cint
    "Number of materials"
    materialCount::Cint
    "Meshes array"
    meshes::Ptr{Mesh}
    "Materials array"
    materials::Ptr{Material}
    "Mesh material number"
    meshMaterial::Ptr{Cint}

    "Animation data"
    "Number of bones"
    boneCount::Cint
    "Bones information (skeleton)"
    bones::Ptr{BoneInfo}
    "Bones base transformation (pose)"
    bindPose::Ptr{Transform}
end

"ModelAnimation"
struct ModelAnimation
    "Number of bones"
    boneCount::Cint
    "Number of animation frames"
    frameCount::Cint
    "Bones information (skeleton)"
    bones::Ptr{BoneInfo}
    "Poses array by frame"
    framePoses::Ptr{Ptr{Transform}}
    "Animation name"
    name::NTuple{32,Cchar}
end

"Ray, ray for raycasting"
struct Ray
    "Ray position (origin)"
    position::Vector3
    "Ray direction"
    direction::Vector3
end

"RayCollision, ray hit information"
struct RayCollision
    "Did the ray hit something?"
    hit::Cint # bool               
    "Distance to the nearest hit"
    distance::Cfloat
    "Point of the nearest hit"
    point::Vector3
    "Surface normal of hit"
    normal::Vector3
end

"BoundingBox"
struct BoundingBox
    "Minimum vertex box-corner"
    min::Vector3
    "Maximum vertex box-corner"
    max::Vector3
end

"Wave, audio wave data"
struct Wave
    "Total number of frames (considering channels)"
    frameCount::Cuint
    "Frequency (samples per second)"
    sampleRate::Cuint
    "Bit depth (bits per sample): 8, 16, 32 (24 not supported)"
    sampleSize::Cuint
    "Number of channels (1-mono, 2-stereo, ...)"
    channels::Cuint
    "Buffer data pointer"
    data::Ptr{Cvoid}
end


# Opaque structs declaration
# NOTE: Actual structs are defined internally in raudio module
#
const rAudioBuffer = Nothing
const rAudioProcessor = Nothing
# TODO: test

"AudioStream, custom audio stream"
struct AudioStream
    "Pointer to internal data used by the audio system"
    buffer::Ptr{rAudioBuffer}
    "Pointer to internal data processor, useful for audio effects"
    processor::Ptr{rAudioProcessor}

    "Frequency (samples per second)"
    sampleRate::Cuint
    "Bit depth (bits per sample): 8, 16, 32 (24 not supported)"
    sampleSize::Cuint
    "Number of channels (1-mono, 2-stereo, ...)"
    channels::Cuint
end

"Sound"
struct Sound
    "Audio stream"
    stream::AudioStream
    "Total number of frames (considering channels)"
    frameCount::Cuint
end

"Music, audio stream, anything longer than ~10 seconds should be streamed"
struct Music
    "Audio stream"
    stream::AudioStream
    "Total number of frames (considering channels)"
    frameCount::Cuint
    "Music looping enable"
    looping::Cint # bool               

    "Type of music context (audio filetype)"
    ctxType::Cint
    "Audio context data, depends on type"
    ctxData::Ptr{Cvoid}
end

"VrDeviceInfo, Head-Mounted-Display device parameters"
struct VrDeviceInfo
    "Horizontal resolution in pixels"
    hResolution::Cint
    "Vertical resolution in pixels"
    vResolution::Cint
    "Horizontal size in meters"
    hScreenSize::Cfloat
    "Vertical size in meters"
    vScreenSize::Cfloat
    "Screen center in meters"
    vScreenCenter::Cfloat
    "Distance between eye and display in meters"
    eyeToScreenDistance::Cfloat
    "Lens separation distance in meters"
    lensSeparationDistance::Cfloat
    "IPD (distance between pupils) in meters"
    interpupillaryDistance::Cfloat
    "Lens distortion constant parameters"
    lensDistortionValues::NTuple{4,Cfloat}
    "Chromatic aberration correction parameters"
    chromaAbCorrection::NTuple{4,Cfloat}
end

"VrStereoConfig, VR stereo rendering configuration for simulator"
struct VrStereoConfig
    "VR projection matrices (per eye)"
    projection::NTuple{2,Matrix}
    "VR view offset matrices (per eye)"
    viewOffset::NTuple{2,Matrix}
    "VR left lens center"
    leftLensCenter::NTuple{2,Cfloat}
    "VR right lens center"
    rightLensCenter::NTuple{2,Cfloat}
    "VR left screen center"
    leftScreenCenter::NTuple{2,Cfloat}
    "VR right screen center"
    rightScreenCenter::NTuple{2,Cfloat}
    "VR distortion scale"
    scale::NTuple{2,Cfloat}
    "VR distortion scale in"
    scaleIn::NTuple{2,Cfloat}
end

"File path list"
struct FilePathList
    "Filepaths max entries"
    capacity::Cuint
    "Filepaths entries count"
    count::Cuint
    "Filepaths entries"
    paths::Ptr{Ptr{Cchar}}
end

"Automation event"
struct AutomationEvent
    "Event frame"
    frame::Cuint
    "Event type (AutomationEventType)"
    type::Cuint
    "Event parameters (if required)"
    params::NTuple{4,Cint}
end

"Automation event list"
struct AutomationEventList
    "Events max entries (MAX_AUTOMATION_EVENTS)"
    capacity::Cuint
    "Events entries count"
    count::Cuint
    "Events entries"
    events::Ptr{AutomationEvent}
end

#----------------------------------------------------------------------------------
# Enumerators Definition
#----------------------------------------------------------------------------------

"""
    System/Window config flags
    NOTE: Every bit registers one state (use it with bit masks)
    By default all flags are set to 0
"""
module ConfigFlags
"Set to try enabling V-Sync on GPU"
const FLAG_VSYNC_HINT::Cint = 0x00000040
"Set to run program in fullscreen"
const FLAG_FULLSCREEN_MODE::Cint = 0x00000002
"Set to allow resizable window"
const FLAG_WINDOW_RESIZABLE::Cint = 0x00000004
"Set to disable window decoration (frame and buttons)"
const FLAG_WINDOW_UNDECORATED::Cint = 0x00000008
"Set to hide window"
const FLAG_WINDOW_HIDDEN::Cint = 0x00000080
"Set to minimize window (iconify)"
const FLAG_WINDOW_MINIMIZED::Cint = 0x00000200
"Set to maximize window (expanded to monitor)"
const FLAG_WINDOW_MAXIMIZED::Cint = 0x00000400
"Set to window non focused"
const FLAG_WINDOW_UNFOCUSED::Cint = 0x00000800
"Set to window always on top"
const FLAG_WINDOW_TOPMOST::Cint = 0x00001000
"Set to allow windows running while minimized"
const FLAG_WINDOW_ALWAYS_RUN::Cint = 0x00000100
"Set to allow transparent framebuffer"
const FLAG_WINDOW_TRANSPARENT::Cint = 0x00000010
"Set to support HighDPI"
const FLAG_WINDOW_HIGHDPI::Cint = 0x00002000
"Set to support mouse passthrough only supported when FLAG_WINDOW_UNDECORATED"
const FLAG_WINDOW_MOUSE_PASSTHROUGH::Cint = 0x00004000
"Set to run program in borderless windowed mode"
const FLAG_BORDERLESS_WINDOWED_MODE::Cint = 0x00008000
"Set to try enabling MSAA 4X"
const FLAG_MSAA_4X_HINT::Cint = 0x00000020
"Set to try enabling interlaced video format (for V3D)"
const FLAG_INTERLACED_HINT::Cint = 0x00010000
end

"""
    Trace log level
    NOTE: Organized by priority level
"""
module TraceLogLevel
"Display all logs"
const LOG_ALL::Cint = 0
"Trace logging, intended for internal use only"
const LOG_TRACE::Cint = 1
"Debug logging, used for internal debugging, it should be disabled on release builds"
const LOG_DEBUG::Cint = 2
"Info logging, used for program execution info"
const LOG_INFO::Cint = 3
"Warning logging, used on recoverable failures"
const LOG_WARNING::Cint = 4
"Error logging, used on unrecoverable failures"
const LOG_ERROR::Cint = 5
"Fatal logging, used to abort program: exit(EXIT_FAILURE)"
const LOG_FATAL::Cint = 6
"Disable logging"
const LOG_NONE::Cint = 7
end

"""
    Keyboard keys (US keyboard layout)
    NOTE: Use GetKeyPressed() to allow redefining
    required keys for alternative layouts
"""
module KeyboardKey
"Key: NULL, used for no key pressed"
const KEY_NULL = 0
# "Alphanumeric keys"
"Key: '"
const KEY_APOSTROPHE = 39
"Key: ,"
const KEY_COMMA = 44
"Key: -"
const KEY_MINUS = 45
"Key: ."
const KEY_PERIOD = 46
"Key: /"
const KEY_SLASH = 47
"Key: 0"
const KEY_ZERO = 48
"Key: 1"
const KEY_ONE = 49
"Key: 2"
const KEY_TWO = 50
"Key: 3"
const KEY_THREE = 51
"Key: 4"
const KEY_FOUR = 52
"Key: 5"
const KEY_FIVE = 53
"Key: 6"
const KEY_SIX = 54
"Key: 7"
const KEY_SEVEN = 55
"Key: 8"
const KEY_EIGHT = 56
"Key: 9"
const KEY_NINE = 57
"Key: ;"
const KEY_SEMICOLON = 59
"Key: ="
const KEY_EQUAL = 61
"Key: A | a"
const KEY_A = 65
"Key: B | b"
const KEY_B = 66
"Key: C | c"
const KEY_C = 67
"Key: D | d"
const KEY_D = 68
"Key: E | e"
const KEY_E = 69
"Key: F | f"
const KEY_F = 70
"Key: G | g"
const KEY_G = 71
"Key: H | h"
const KEY_H = 72
"Key: I | i"
const KEY_I = 73
"Key: J | j"
const KEY_J = 74
"Key: K | k"
const KEY_K = 75
"Key: L | l"
const KEY_L = 76
"Key: M | m"
const KEY_M = 77
"Key: N | n"
const KEY_N = 78
"Key: O | o"
const KEY_O = 79
"Key: P | p"
const KEY_P = 80
"Key: Q | q"
const KEY_Q = 81
"Key: R | r"
const KEY_R = 82
"Key: S | s"
const KEY_S = 83
"Key: T | t"
const KEY_T = 84
"Key: U | u"
const KEY_U = 85
"Key: V | v"
const KEY_V = 86
"Key: W | w"
const KEY_W = 87
"Key: X | x"
const KEY_X = 88
"Key: Y | y"
const KEY_Y = 89
"Key: Z | z"
const KEY_Z = 90
"Key: ["
const KEY_LEFT_BRACKET = 91
"Key: '\\'"
const KEY_BACKSLASH = 92
"Key: ]"
const KEY_RIGHT_BRACKET = 93
"Key: `"
const KEY_GRAVE = 96

#"Function keys"
"Key: Space"
const KEY_SPACE = 32
"Key: Esc"
const KEY_ESCAPE = 256
"Key: Enter"
const KEY_ENTER = 257
"Key: Tab"
const KEY_TAB = 258
"Key: Backspace"
const KEY_BACKSPACE = 259
"Key: Ins"
const KEY_INSERT = 260
"Key: Del"
const KEY_DELETE = 261
"Key: Cursor right"
const KEY_RIGHT = 262
"Key: Cursor left"
const KEY_LEFT = 263
"Key: Cursor down"
const KEY_DOWN = 264
"Key: Cursor up"
const KEY_UP = 265
"Key: Page up"
const KEY_PAGE_UP = 266
"Key: Page down"
const KEY_PAGE_DOWN = 267
"Key: Home"
const KEY_HOME = 268
"Key: End"
const KEY_END = 269
"Key: Caps lock"
const KEY_CAPS_LOCK = 280
"Key: Scroll down"
const KEY_SCROLL_LOCK = 281
"Key: Num lock"
const KEY_NUM_LOCK = 282
"Key: Print screen"
const KEY_PRINT_SCREEN = 283
"Key: Pause"
const KEY_PAUSE = 284
"Key: F1"
const KEY_F1 = 290
"Key: F2"
const KEY_F2 = 291
"Key: F3"
const KEY_F3 = 292
"Key: F4"
const KEY_F4 = 293
"Key: F5"
const KEY_F5 = 294
"Key: F6"
const KEY_F6 = 295
"Key: F7"
const KEY_F7 = 296
"Key: F8"
const KEY_F8 = 297
"Key: F9"
const KEY_F9 = 298
"Key: F10"
const KEY_F10 = 299
"Key: F11"
const KEY_F11 = 300
"Key: F12"
const KEY_F12 = 301
"Key: Shift left"
const KEY_LEFT_SHIFT = 340
"Key: Control left"
const KEY_LEFT_CONTROL = 341
"Key: Alt left"
const KEY_LEFT_ALT = 342
"Key: Super left"
const KEY_LEFT_SUPER = 343
"Key: Shift right"
const KEY_RIGHT_SHIFT = 344
"Key: Control right"
const KEY_RIGHT_CONTROL = 345
"Key: Alt right"
const KEY_RIGHT_ALT = 346
"Key: Super right"
const KEY_RIGHT_SUPER = 347
"Key: KB menu"
const KEY_KB_MENU = 348

#"Keypad keys"
"Key: Keypad 0"
const KEY_KP_0 = 320
"Key: Keypad 1"
const KEY_KP_1 = 321
"Key: Keypad 2"
const KEY_KP_2 = 322
"Key: Keypad 3"
const KEY_KP_3 = 323
"Key: Keypad 4"
const KEY_KP_4 = 324
"Key: Keypad 5"
const KEY_KP_5 = 325
"Key: Keypad 6"
const KEY_KP_6 = 326
"Key: Keypad 7"
const KEY_KP_7 = 327
"Key: Keypad 8"
const KEY_KP_8 = 328
"Key: Keypad 9"
const KEY_KP_9 = 329
"Key: Keypad ."
const KEY_KP_DECIMAL = 330
"Key: Keypad /"
const KEY_KP_DIVIDE = 331
"Key: Keypad *"
const KEY_KP_MULTIPLY = 332
"Key: Keypad -"
const KEY_KP_SUBTRACT = 333
"Key: Keypad +"
const KEY_KP_ADD = 334
"Key: Keypad Enter"
const KEY_KP_ENTER = 335
"Key: Keypad ="
const KEY_KP_EQUAL = 336

#"Android key buttons"
"Key: Android back button"
const KEY_BACK = 4
"Key: Android menu button"
const KEY_MENU = 82
"Key: Android volume up button"
const KEY_VOLUME_UP = 24
"Key: Android volume down button"
const KEY_VOLUME_DOWN = 25
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
    (@ccall raylib.WindowShouldClose()::Cint) != 0
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
