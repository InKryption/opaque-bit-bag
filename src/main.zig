const std = @import("std");
const debug = std.debug;
const builtin = std.builtin;
const testing = std.testing;

const assert = debug.assert;

pub fn OpaqueBitBag(comptime T: type) type {
    comptime assert(@sizeOf(T) > 0);
    @setEvalBranchQuota(1000 + @bitSizeOf(T) * 1000);
    
    const Bit = enum(u1) { _ };
    const fields: []const builtin.TypeInfo.StructField = fields: {
        var fields_result: []const builtin.TypeInfo.StructField = &.{};
        
        var bit_idx = 0;
        while (bit_idx < @bitSizeOf(T)) : (bit_idx += 1) {
            fields_result = fields_result ++ [_]builtin.TypeInfo.StructField{
                .{
                    .name = std.fmt.comptimePrint("{d}", .{ bit_idx }),
                    .field_type = Bit,
                    .default_value = @as(?Bit, null),
                    .is_comptime = false,
                    .alignment = 1,
                },
            };
        }
        
        break :fields fields_result;
    };
    
    return @Type(.{ .Struct = builtin.TypeInfo.Struct {
        .layout = .Packed,
        .fields = fields,
        .decls = &.{},
        .is_tuple = false,
    } });
}
