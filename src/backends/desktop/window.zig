const glfw = @import("zglfw");
const core = @import("../../core/main.zig");

pub const WindowImpl = struct {
    const Self = *@This();

    win: *glfw.Window,

    pub fn init(opts: core.WindowOptions) !WindowImpl {
        try glfw.init();
        var win = try glfw.Window.create(@intCast(opts.width), @intCast(opts.height), opts.title, null);
        glfw.makeContextCurrent(win);
        glfw.swapInterval(1);

        return WindowImpl{
            .win = win,
        };
    }

    pub fn loop(self: Self) void {
        while (!self.win.shouldClose()) {
            glfw.pollEvents();

            //std.debug.print("here\n", .{});

            self.win.swapBuffers();
        }
    }

    pub fn deinit(self: Self) void {
        const std = @import("std");
        std.debug.print("\nCleaning window Impl glfw", .{});
        self.win.destroy();
        glfw.terminate();
        std.debug.print("\nCleaned window Impl glfw", .{});
    }
};
