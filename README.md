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


update 01-03-2022  6:00 pm
mix_col and shift_rows are also done using tasks 
mix_col operates on a word (32 bits) while shift_rows operate ona whole state (128 bits)
both are verified using a testbench


update 01-03-222 09:30 pm
encryption is done ..
tested with the data and key given in official document
everything is in verilog and implemented using tasks
although the code may seem very jagged and messy , i will clean and include packages (ike vhdl) for task definition later.
the file "encryptio.v" runs well on RTL simulation and you can see the key_expansion output in it too
