const std = @import("std");
const core = @import("../../core/main.zig");
const WindowImpl = @import("./window.zig").WindowImpl;

pub const Backend = struct {
    const Self = *@This();

    window: core.Window(WindowImpl),

    pub fn init(allocator: std.mem.Allocator, opts: core.BackendOptions) !Backend {
        var window = try core.Window(WindowImpl).init(allocator, opts.window);
        return Backend{
            .window = window,
        };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        std.debug.print("\nCleaning backend...", .{});
        self.window.deinit(allocator);
        std.debug.print("\nBackend cleaned\n", .{});
    }
};
