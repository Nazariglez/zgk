const glfw = @import("zglfw");
const core = @import("../../core/main.zig");

pub const WindowImpl = struct {
    const Self = @This();

    win: *glfw.Window,
    min_limits: [2]i32,
    max_limits: [2]i32,

    pub fn init(opts: core.WindowOptions) !WindowImpl {
        try glfw.init();
        var win = try glfw.Window.create(@intCast(opts.width), @intCast(opts.height), opts.title, null);
        glfw.makeContextCurrent(win);
        glfw.swapInterval(1);

        var min_limits = [_]i32{ opt_u32_as_i32(opts.min_width), opt_u32_as_i32(opts.min_height) };
        var max_limits = [_]i32{ opt_u32_as_i32(opts.max_width), opt_u32_as_i32(opts.max_height) };
        win.setSizeLimits(min_limits[0], min_limits[1], max_limits[0], max_limits[1]);

        win.setAttribute(.resizable, opts.resizable);
        win.setAttribute(.visible, opts.visible);

        // todo: maximized not working
        win.setAttribute(.maximized, opts.maximized);

        // todo: fullscreen
        // todo: position

        return WindowImpl{
            .win = win,
            .min_limits = min_limits,
            .max_limits = max_limits,
        };
    }

    pub fn set_title(self: *Self, t: [:0]const u8) void {
        self.win.setTitle(t);
    }

    pub fn set_size(self: *Self, width: u32, height: u32) void {
        self.win.setSize(@intCast(width), @intCast(height));
    }

    pub fn set_min_size(self: *Self, w: ?u32, h: ?u32) void {
        self.min_limits[0] = opt_u32_as_i32(w);
        self.min_limits[1] = opt_u32_as_i32(h);
        self.win.setSizeLimits(self.min_limits[0], self.min_limits[1], self.max_limits[0], self.max_limits[1]);
    }

    pub fn set_max_size(self: *Self, w: ?u32, h: ?u32) void {
        self.max_limits[0] = opt_u32_as_i32(w);
        self.max_limits[1] = opt_u32_as_i32(h);
        self.win.setSizeLimits(self.min_limits[0], self.min_limits[1], self.max_limits[0], self.max_limits[1]);
    }

    pub fn set_resizable(self: *Self, value: bool) void {
        self.win.setAttribute(.resizable, value);
    }

    pub fn set_maximized(self: *Self, value: bool) void {
        self.win.setAttribute(.maximized, value);
    }

    pub fn set_visible(self: *Self, value: bool) void {
        self.win.setAttribute(.visible, value);
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

fn opt_u32_as_i32(n: ?u32) i32 {
    if (n) |num| {
        return @intCast(num);
    }

    return -1;
}
