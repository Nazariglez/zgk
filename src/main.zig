const std = @import("std");
const Backend = @import("./backends/desktop/main.zig").Backend;

pub fn start() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = .{ .window = .{
        .title = "Super Duper Window",
    } };
    var backend = try Backend.init(options);
    defer backend.deinit();

    std.debug.print("\nsize: {any}\n", .{backend.window.size()});
    backend.window.set_size(400, 400);
    std.debug.print("\nsize: {any}\n", .{backend.window.size()});

    backend.window.loop();
}
