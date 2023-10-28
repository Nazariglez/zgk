const core = @import("../../core/main.zig");
const WindowImpl = @import("./window.zig").WindowImpl;

pub const Backend = struct {
    const Self = *@This();
    
    window: core.Window(WindowImpl),
    
    pub fn init(opts: core.BackendOptions) !Backend {
        var window = try core.Window(WindowImpl).init(opts.window);
        return Backend {
            .window = window,
        };
    }

    pub fn deinit(self: Self) void {
        self.window.deinit();
    }
};