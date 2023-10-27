const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = createLib(b, target, optimize);
    //const lib = createExe(b, target, optimize);

    // examples
    addExamples(b, lib, target, optimize);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}

pub fn createLib(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) *std.Build.CompileStep {
    const lib = b.addStaticLibrary(.{
        .name = "zgk",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const lib_options = b.addOptions();
    lib_options.addOption(bool, "empty", false);

    lib.addOptions("build_options", lib_options);

    // deps
    addDependencies(b, lib, target, optimize);

    b.installArtifact(lib);

    return lib;
}

pub fn createExe(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) *std.Build.CompileStep {
    const exe = b.addExecutable(.{
        .name = "zgk",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    // deps
    addDependencies(b, exe, target, optimize);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    return exe;
}

fn createModule(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    const zglfw = @import("deps/zig-gamedev/libs/zglfw/build.zig");
    const zglfw_pkg = zglfw.package(b, target, optimize, .{});

    return b.createModule(.{
        .source_file = .{ .path = thisDir() ++ "/src/main.zig" },
        .dependencies = &.{
            .{ .name = "zglfw", .module = zglfw_pkg.zglfw },
        },
    });
}

fn addDependencies(b: *std.Build, lib: *std.Build.CompileStep, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) void {
    const zglfw = @import("deps/zig-gamedev/libs/zglfw/build.zig");
    const zglfw_pkg = zglfw.package(b, target, optimize, .{});
    zglfw_pkg.link(lib);
}

fn addExamples(b: *std.Build, lib: *std.Build.CompileStep, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) void {
        addExample(b,  "gfx_triangle", lib, target, optimize);
}

// adapted from zig-gamedev
fn addExample(b: *std.Build, comptime name: []const u8, lib: *std.Build.CompileStep, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode) void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = .{ .path = thisDir() ++ "/examples/" ++ name ++ "/src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    exe.want_lto = false;
    exe.strip = optimize == .ReleaseFast;

    exe.addModule("zgk", createModule(b, target, optimize));
    exe.linkLibrary(lib);

    //_ = lib;
    //exe.addModule("zgk", lib.module(b));

    const install_step = b.step(name, "Build '" ++ name ++ "' example");
    install_step.dependOn(&b.addInstallArtifact(exe, .{}).step);

    const run_step = b.step(name ++ "-run", "Run '" ++ name ++ "' example");
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(install_step);
    run_step.dependOn(&run_cmd.step);

    b.getInstallStep().dependOn(install_step);
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}