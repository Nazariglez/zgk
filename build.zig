const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zgk",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);

    addExamples(b, target, optimize);
}

fn addExamples(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) void {
    const gfx_triangle = @import("examples/gfx_triangle/build.zig").build(b, target, optimize);
    addExample(b, gfx_triangle, "gfx_triangle");
}

// adapted from zig-gamedev
fn addExample(b: *std.Build, exe: *std.Build.CompileStep, comptime name: []const u8) void {
    exe.want_lto = false;
    if (exe.optimize == .ReleaseFast) {
        exe.strip = true;
    }

    const install_step = b.step(name, "Build '" ++ name ++ "' example");
    install_step.dependOn(&b.addInstallArtifact(exe, .{}).step);

    const run_step = b.step(name ++ "-run", "Run '" ++ name ++ "' example");
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(install_step);
    run_step.dependOn(&run_cmd.step);

    b.getInstallStep().dependOn(install_step);
}