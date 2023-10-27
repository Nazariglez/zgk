pub const WindowOptions = struct {
    title: []u8 = "zkg window",
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

pub const Window = struct {
    ptr: *anyopaque,
    initFn: *const fn (ptr: *anyopaque, options: WindowOptions) anyerror!Window,

    fn init(ptr: anytype) Window {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);

        const gen = struct {
            pub fn init(pointer: *anyopaque, options: WindowOptions) anyerror!Window {
                const self: T = @ptrCast(@alignCast(pointer));
                return ptr_info.Pointer.child.init(self, options);
            }
        };

        return .{
            .ptr = ptr,
            .initFn = gen.init,
        };
    }
};

// https://www.openmymind.net/Zig-Interfaces/
