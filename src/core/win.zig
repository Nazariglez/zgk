const std = @import("std");

pub const WindowOptions = struct {
    title: [:0]const u8 = "zkg window",
    width: u32 = 800,
    height: u32 = 600,
    max_width: ?u32 = null,
    max_height: ?u32 = null,
    min_width: ?u32 = null,
    min_height: ?u32 = null,
    resizable: bool = false,
    maximized: bool = false,
    fullscreen: bool = false,
};

pub fn Window(comptime T: type) type {
    return struct {
        const Self = @This();
        impl: T,

        pub fn init(opts: WindowOptions) !Self {
            const impl = try T.init(opts);
            return Self{
                .impl = impl,
            };
        }

        fn size(self: *const Self) [2]u32 {
            return self.impl.size();
        }

        pub fn loop(self: *Self) void {
            self.impl.loop();
        }

        pub fn deinit(self: *Self) void {
            std.debug.print("\nCleaning Window", .{});
            self.impl.deinit();
            std.debug.print("\nWindow cleaned {*} ", .{&self.impl});
        }
    };
}
