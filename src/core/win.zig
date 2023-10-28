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

        fn size(self: *Self) [2]u32 {
            return self.impl.size;
        }

        fn set_size(self: *Self, width: u32, height: u32) void {
            self.impl.size[0] = width;
            self.impl.size[1] = height;
        }

        pub fn loop(self: *Self) void {
            self.impl.loop();
        }

        pub fn deinit(self: Self) void {
            _ = self;
            //self.impl.deinit();
        }
    };
}

// https://www.openmymind.net/Zig-Interfaces/
