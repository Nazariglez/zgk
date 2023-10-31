const std = @import("std");

pub const WindowOptions = struct {
    title: [:0]const u8 = "zkg window",
    width: u32 = 800,
    height: u32 = 600,
    max_width: ?u32 = null,
    max_height: ?u32 = null,
    min_width: ?u32 = null,
    min_height: ?u32 = null,
    position_x: ?u32 = null,
    position_y: ?u32 = null,
    visible: bool = true,
    resizable: bool = true,
    maximized: bool = false,
    fullscreen: bool = false,
};

pub fn Window(comptime T: type) type {
    return struct {
        const Self = @This();
        _impl: T,
        _title: [:0]const u8,
        _size: [2]u32,
        _max_size: [2]?u32,
        _min_size: [2]?u32,
        _position: ?[2]u32,
        _visible: bool,
        _resizable: bool,
        _maximized: bool,
        _fullscreen: bool,

        pub fn init(allocator: std.mem.Allocator, opts: WindowOptions) !Self {
            const _impl = try T.init(allocator, opts);
            const has_position = (opts.position_x != null and opts.position_y != null);
            const position = if (has_position) [_]u32{ opts.position_x.?, opts.position_y.? } else null;
            return Self{
                ._impl = _impl,
                ._title = opts.title,
                ._size = [_]u32{ opts.width, opts.height },
                ._max_size = [_]?u32{ opts.max_width, opts.max_height },
                ._min_size = [_]?u32{ opts.min_width, opts.min_height },
                ._position = position,
                ._visible = opts.visible,
                ._resizable = opts.resizable,
                ._maximized = opts.maximized,
                ._fullscreen = opts.fullscreen,
            };
        }

        pub fn title(self: *const Self) [:0]const u8 {
            return self._title;
        }

        pub fn set_title(self: *Self, t: [:0]const u8) void {
            self._impl.set_title(t);
            self._title = t;
        }

        pub fn size(self: *const Self) [2]u32 {
            return self._size;
        }

        pub fn set_size(self: *Self, w: u32, h: u32) void {
            self._impl.set_size(w, h);
            self._size[0] = w;
            self._size[1] = h;
        }

        pub fn width(self: *const Self) u32 {
            return self._size[0];
        }

        pub fn height(self: *const Self) u32 {
            return self._size[1];
        }

        pub fn max_size(self: *const Self) [2]?u32 {
            return self._max_size;
        }

        pub fn set_max_size(self: *Self, w: ?u32, h: ?u32) void {
            self._impl.set_max_size(w, h);
            self._max_size[0] = w;
            self._max_size[1] = h;
        }

        pub fn max_width(self: *const Self) ?u32 {
            return self._max_size[0];
        }

        pub fn max_height(self: *const Self) ?u32 {
            return self._max_size[1];
        }

        pub fn min_size(self: *const Self) ?[2]u32 {
            return self._min_size;
        }

        pub fn set_min_size(self: *Self, w: ?u32, h: ?u32) void {
            self._impl.set_min_size(w, h);
            self._min_size[0] = w;
            self._max_size[1] = h;
        }

        pub fn min_width(self: *const Self) ?u32 {
            return self._min_size[0];
        }

        pub fn min_height(self: *const Self) ?u32 {
            return self._min_size[1];
        }

        pub fn set_resizable(self: *Self, value: bool) void {
            self._resizable = value;
            self._impl.set_resizable(value);
        }

        pub fn resizable(self: *const Self) bool {
            return self._resizable;
        }

        pub fn set_maximized(self: *Self, value: bool) void {
            self._maximized = value;
            self._impl.set_maximized(value);
        }

        pub fn maximized(self: *const Self) bool {
            return self._maximized;
        }

        pub fn set_visible(self: *Self, value: bool) void {
            self._visible = value;
            self._impl.set_visible(value);
        }

        pub fn visible(self: *const Self) bool {
            return self._visible;
        }

        pub fn loop(self: *Self) void {
            self._impl.loop();
        }

        pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
            std.debug.print("\nCleaning Window", .{});
            self._impl.deinit(allocator);
            std.debug.print("\nWindow cleaned {*} ", .{&self._impl});
        }
    };
}
