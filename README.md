# AES-FPGA_VERILOG
update-26-02-2022
key expansion is done
verilog is used and not systemverilog
modified some tasks which i defined earlier
"key-expansion.v" contains all the tasks definition and keyexpansion routine..reading only this file would cover all aspects
rcon.mem has been changed a little(not significant changes)
multi-dim arrays are hard to handle in verilog , so code is not highly optimised and contains many redundant portions to make code more editable and readable.
rtl sim matches the desired output
fate level sim is yet to be performed

update - 01-03-2022
made some modification in key_expansion code.
a lot of thing were tough to incorporate in a loop earlier..
so a more compact code is written now. algorrithm and steps are exactly same as previous uploaded code . only some things are written in a "for" loop
for a better understanding read both the codes .
