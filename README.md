This is for me, myself, and I for revising how to use SystemVerilog.

Result = op1 * op2 

Input signals:
op1, op2, Request

Output signals:
Result, Done

Control signals:
Clock, nReset

Specification (self-set): 

- 'Done' is HIGH when the system is ready to take in a 'Request' or has finished the multiplication
- 'Result' remains until the next 'Request'
- The inputs op1, op2 does not have to remain after the initial 'Request'
- Parameterised number of bits

Hierarchy:
- boothsmult.sv
  - control.sv
  - mult.sv
