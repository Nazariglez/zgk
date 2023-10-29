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
        impl: ?*T,

        pub fn init(allocator: *std.mem.Allocator, opts: WindowOptions) !Self {
            var impl = try allocator.create(T);
            impl.* = try T.init(opts);
            return Self{
                .impl = impl,
            };
        }

        fn size(self: *Self) [2]u32 {
            return self.impl.?.size();
        }

        pub fn loop(self: *Self) void {
            self.impl.?.loop();
        }

        pub fn deinit(self: Self) void {
            std.debug.print("\nCleaning Window", .{});
            var s = self;
            var impl = self.impl.?;
            s.impl = null;
            impl.deinit();
            std.debug.print("\nWindow cleaned {*} {*} {*}", .{ &s.impl, &impl, &self.impl });
        }
    };
}
