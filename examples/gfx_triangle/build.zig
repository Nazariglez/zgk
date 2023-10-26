const std = @import("std");

pub fn build(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) *std.build.CompileStep {
    const exe = b.addExecutable(.{
        .name = "gfx_triangle",
        .root_source_file = .{ .path = thisDir() ++ "/src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}