let r0 0x01000000
copy r1 0
copy r2 0
copy r5 0
copy r7 1
let r4 0x0000D1FF
let r6 0x00399600

line:
    store [r1+r0] r4
    skip 1 ifge r5 r7
        store [r1+r0] r6
    add r1 r1 4
    add r5 r5 1
    skipto chgt_color iflt r5 640
        copy r5 0
        add r2 r2 1
        add r7 r7 1
        skipto chgt_color iflt r2 241
        add r7 r7 -2
    chgt_color:
    skipto loop_continue iflt r2 120
    copy r4 -1
    skipto loop_continue iflt r2 240
    let r4 0x004033EF 
    skipto loop_continue iflt r2 360
    let r4 0x00A53D00


    loop_continue:
    skip 1 ifgt r2 479
        jump line
hhalt:
    nop
    jump hhalt
halt
