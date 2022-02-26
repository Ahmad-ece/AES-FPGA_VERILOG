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
