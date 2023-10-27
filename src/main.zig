const std = @import("std");
const glfw = @import("zglfw");

pub fn open() !void {
    try glfw.init();
    defer glfw.terminate();

    const window = try glfw.Window.create(800, 600, "zgk!", null);
    defer window.destroy();

    glfw.makeContextCurrent(window);

    glfw.swapInterval(1);

    while (!window.shouldClose()) {
        glfw.pollEvents();

        std.debug.print("here\n", .{});

        window.swapBuffers();
    }
}

pub fn main() !void {
    try open();
}
