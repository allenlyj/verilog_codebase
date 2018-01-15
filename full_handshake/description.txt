A modular cross clock domain full handshake logic. 

Transfers generic bit of data from tclk to rclk. When capable of transfer, incapable gets high (in transmitter clock domain).
When transfer reaches receiver interface, output_valid gets high (in receiver clock domain). 