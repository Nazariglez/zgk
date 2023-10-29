const glfw = @import("zglfw");
const core = @import("../../core/main.zig");

pub const WindowImpl = struct {
    const Self = @This();

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

    pub fn size(self: *const Self) [2]u32 {
        const win_size = self.win.getSize();
        return size_as_u32(win_size);
    }

    pub fn set_size(self: *Self, width: u32, height: u32) void {
        self.win.setSize(@intCast(width), @intCast(height));
    }

    pub fn loop(self: *Self) void {
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

fn i32_as_u32(n: i32) u32 {
    if (n < 0) {
        return 0;
    }

    return @intCast(n);
}

fn size_as_u32(size: [2]i32) [2]u32 {
    return [_]u32{ i32_as_u32(size[0]), i32_as_u32(size[1]) };
}
