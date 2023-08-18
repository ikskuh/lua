const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const enable_interpreter = b.option(bool, "interpreter", "Installs the lua interpreter") orelse true;
    const enable_compiler = b.option(bool, "compiler", "Installs the lua compiler") orelse true;
    const enable_shared_lib = b.option(bool, "shared-lib", "Installs the lua shared library") orelse true;
    const enable_static_lib = b.option(bool, "static-lib", "Installs the lua static library") orelse true;
    const enable_headers = b.option(bool, "headers", "Installs the lua headers") orelse true;

    const cflags = [_][]const u8{ "-std=gnu99", "-Wall", "-Wextra" };

    if (enable_interpreter) {
        const lua = b.addExecutable(.{
            .name = "lua",
            .version = .{ .major = 5, .minor = 4, .patch = 4 },
            .target = target,
            .optimize = optimize,
        });
        lua.defineCMacro("LUA_COMPAT_5_3", null);
        lua.addCSourceFiles(&core_files, &cflags);
        lua.addCSourceFiles(&lib_files, &cflags);
        lua.addCSourceFile(.{ .file = .{ .path = "src/lua.c" }, .flags = &cflags });
        lua.linkLibC();
        b.installArtifact(lua);
    }

    if (enable_compiler) {
        const lua = b.addExecutable(.{
            .name = "luac",
            .version = .{ .major = 5, .minor = 4, .patch = 4 },
            .target = target,
            .optimize = optimize,
        });
        lua.defineCMacro("LUA_COMPAT_5_3", null);
        lua.addCSourceFiles(&core_files, &cflags);
        lua.addCSourceFiles(&lib_files, &cflags);
        lua.addCSourceFile(.{ .file = .{ .path = "src/luac.c" }, .flags = &cflags });
        lua.linkLibC();
        b.installArtifact(lua);
    }

    if (enable_shared_lib) {
        const lua = b.addSharedLibrary(.{
            .name = "lua",
            .version = .{ .major = 5, .minor = 4, .patch = 4 },
            .target = target,
            .optimize = optimize,
        });
        lua.defineCMacro("LUA_COMPAT_5_3", null);
        lua.addCSourceFiles(&core_files, &cflags);
        lua.addCSourceFiles(&lib_files, &cflags);
        lua.linkLibC();
        b.installArtifact(lua);
    }

    if (enable_static_lib) {
        const lua = b.addStaticLibrary(.{
            .name = "lua",
            .version = .{ .major = 5, .minor = 4, .patch = 4 },
            .target = target,
            .optimize = optimize,
        });
        lua.defineCMacro("LUA_COMPAT_5_3", null);
        lua.addCSourceFiles(&core_files, &cflags);
        lua.addCSourceFiles(&lib_files, &cflags);
        lua.linkLibC();
        b.installArtifact(lua);
    }

    if (enable_headers) {
        b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lua.h", "lua5.4/lua.h").step);
        b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/luaconf.h", "lua5.4/luaconf.h").step);
        b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lualib.h", "lua5.4/lualib.h").step);
        b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lauxlib.h", "lua5.4/lauxlib.h").step);
        b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lua.hpp", "lua5.4/lua.hpp").step);
    }
}

const core_files = [_][]const u8{
    "src/lapi.c",    "src/lcode.c",
    "src/lctype.c",  "src/ldebug.c",
    "src/ldo.c",     "src/ldump.c",
    "src/lfunc.c",   "src/lgc.c",
    "src/llex.c",    "src/lmem.c",
    "src/lobject.c", "src/lopcodes.c",
    "src/lparser.c", "src/lstate.c",
    "src/lstring.c", "src/ltable.c",
    "src/ltm.c",     "src/lundump.c",
    "src/lvm.c",     "src/lzio.c",
};

const lib_files = [_][]const u8{
    "src/lauxlib.c",  "src/lbaselib.c",
    "src/lcorolib.c", "src/ldblib.c",
    "src/liolib.c",   "src/lmathlib.c",
    "src/loadlib.c",  "src/loslib.c",
    "src/lstrlib.c",  "src/ltablib.c",
    "src/lutf8lib.c", "src/linit.c",
};
