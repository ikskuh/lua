const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cflags = [_][]const u8{ "-std=gnu99", "-Wall", "-Wextra" };

    {
        const lua = b.addExecutable(.{
            .name = "lua",
            .version = .{ .major = 5, .minor = 4, .patch = 4 },
            .target = target,
            .optimize = optimize,
        });
        lua.defineCMacro("LUA_COMPAT_5_3", null);
        lua.addCSourceFiles(&core_files, &cflags);
        lua.addCSourceFiles(&lib_files, &cflags);
        lua.addCSourceFile("src/lua.c", &cflags);
        lua.linkLibC();
        lua.install();
    }

    {
        const lua = b.addExecutable(.{
            .name = "luac",
            .version = .{ .major = 5, .minor = 4, .patch = 4 },
            .target = target,
            .optimize = optimize,
        });
        lua.defineCMacro("LUA_COMPAT_5_3", null);
        lua.addCSourceFiles(&core_files, &cflags);
        lua.addCSourceFiles(&lib_files, &cflags);
        lua.addCSourceFile("src/luac.c", &cflags);
        lua.linkLibC();
        lua.install();
    }
    {
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
        lua.install();
    }
    {
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
        lua.install();
    }

    b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lua.h", "lua5.4/lua.h").step);
    b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/luaconf.h", "lua5.4/luaconf.h").step);
    b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lualib.h", "lua5.4/lualib.h").step);
    b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lauxlib.h", "lua5.4/lauxlib.h").step);
    b.getInstallStep().dependOn(&b.addInstallHeaderFile("src/lua.hpp", "lua5.4/lua.hpp").step);
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
