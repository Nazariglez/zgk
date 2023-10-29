const std = @import("std");
const core = @import("../../core/main.zig");
const WindowImpl = @import("./window.zig").WindowImpl;

pub const Backend = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    window: core.Window(WindowImpl),

    pub fn init(allocator: std.mem.Allocator, opts: core.BackendOptions) !Backend {
        var alloc = allocator;
        var window = try core.Window(WindowImpl).init(&alloc, opts.window);
        return Backend{
            .allocator = alloc,
            .window = window,
        };
    }

    pub fn deinit(self: Self) void {
        std.debug.print("\nCleaning backend...", .{});
        self.window.deinit();
        std.debug.print("\nBackend cleaned\n", .{});
    }
};
