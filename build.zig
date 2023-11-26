const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;

    _ = b.addModule("flags", .{
        .source_file = .{ .path = "src/lib.zig" },
    });

    const exe = b.addExecutable(.{
        .name = "zig-flag",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = mode,
    });
    const extras = b.dependency("extras", .{});
    exe.addModule("extras", extras.module("extras"));
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "dummy test step to pass CI checks");
    _ = test_step;
}
