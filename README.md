## Summary
The error injection tool is for inducing single errors into the FPGA configuration, to simulate the behaviour 
of radiation induced single event effects (SEE) in the FPGA configuration. 

For this the radiation hardened design and a golden design are implemented into the FPGA. A sequencer core gives 
a defined sequence as test input. An internal compare circuit writes the results back to the computer.

In the first step the python tool generates a mask file for internal use. This mask file is used to only manipulated
the radiation hardened design and not the test logic. Now the tool generates a manipulated bitfile for the FPGA. The 
tool automatically opens impact and programs the FPGA, with the generated file. Now the Tool checks for a response of 
the compare core. If it is correct, the next manipulated file is generated. If the response is incorrect the bitfile 
is logged and the test goes on.
