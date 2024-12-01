const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
    const allocator = gpa.allocator();

    const path = "/home/rusty/Development/aoc-24/day01.txt";
    var f = try std.fs.openFileAbsolute(path, .{ .mode = .read_only });
    defer f.close();

    var reader = f.reader();
    var leftList = std.ArrayList(isize).init(allocator);
    var rightList = std.ArrayList(isize).init(allocator);
    defer leftList.deinit();
    defer rightList.deinit();

    while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(isize))) |line| {
        defer allocator.free(line);
        var it = std.mem.splitSequence(u8, line, "   ");
        if (it.next()) |x| {
            try leftList.append(try std.fmt.parseInt(isize, x, 10));
        }
        if (it.next()) |x| {
            try rightList.append(try std.fmt.parseInt(isize, x, 10));
        }
    }

    std.mem.sort(isize, leftList.items, {}, comptime std.sort.asc(isize));
    std.mem.sort(isize, rightList.items, {}, comptime std.sort.asc(isize));

    var distance: u64 = 0;
    for (leftList.items, 0..) |leftValue, index| {
        const rightValue = rightList.items[index];
        distance += @abs(leftValue - rightValue);
    }

    std.debug.print("{d}\n", .{distance});
}
