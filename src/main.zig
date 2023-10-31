const std = @import("std");
const Backend = @import("./backends/desktop/main.zig").Backend;

pub fn start() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const options = .{
        .window = .{
            .title = "Super Duper Window",
            .resizable = true,
            .maximized = true,
        },
    };
    var backend = try Backend.init(allocator, options);
    defer backend.deinit(allocator);

    std.debug.print("\nsize: {any}\n", .{backend.window.size()});
    // backend.window.set_size(400, 400);
    backend.window.set_title("Nuevo titulo");
    backend.window.set_maximized(true);
    // backend.window.set_min_size(300, 300);
    // backend.window.set_max_size(500, 500);
    // backend.window.set_resizable(false);
    std.debug.print(
        \\size: {any},
        \\title: {s},
    , .{ backend.window.size(), backend.window.title() });

    backend.window.loop();
}
