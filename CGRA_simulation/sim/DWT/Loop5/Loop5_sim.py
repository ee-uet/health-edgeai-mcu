import sys
sys.path.append("../../../src/")
import cgra
from sat_to_csv import *
from kernels import *

# Kernels will be located in a folder with the kernel's name
kernel_name = "../Loop5"

kernel_new(kernel_name)

# If you have a assembly in the SAT-MapIt format, you can convert it to a csv
convert( kernel_name+"/out.sat", kernel_name+"/instructions.csv")

# Set load address
load_addrs = [100, 108, 116, 0]

# Start the simulation
cgra.run( kernel_name, pr=["ROUT", "R0","INST"], limit=10000, load_addrs=load_addrs)

