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

    backend.window.loop();
}
