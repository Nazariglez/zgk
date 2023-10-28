const std = @import("std");
const Backend = @import("./backends/desktop/main.zig").Backend;
//const glfw = @import("zglfw");

//pub fn open() !void {
//    try glfw.init();
//    defer glfw.terminate();
//
//    const window = try glfw.Window.create(800, 600, "zgk!", null);
//    defer window.destroy();

//    glfw.makeContextCurrent(window);

//    glfw.swapInterval(1);

//    while (!window.shouldClose()) {
//        glfw.pollEvents();

//        std.debug.print("here\n", .{});

//        window.swapBuffers();
//    }
//}

pub fn start() !void {
    const options = .{ .window = .{
        .title = "Super Duper Window",
    } };
    var backend = try Backend.init(options);
    defer backend.deinit();

    backend.window.loop();
    //try open();
}
