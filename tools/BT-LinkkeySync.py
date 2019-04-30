#!/usr/bin/env python

from plistlib import *
import os
from pprint import *
import subprocess

print("---------------------------------")
print("  BT-Linkkeysync by DigitalBird")
print("---------------------------------")

# file where the registry info shall be stored
filename = 'btkeys.reg'

print("> get Bluetooth Link Keys from macOS and store it to blued.plist")
output = subprocess.check_output("sudo defaults export /private/var/root/Library/Preferences/com.apple.bluetoothd.plist ./blued.plist", shell=True)
output = subprocess.check_output("sudo chown $USER ./blued.plist", shell=True)

print("> convert exported list from binary to xml")
output = subprocess.check_output("plutil -convert xml1 ./blued.plist", shell=True)

print("> parse the converted plist")
pl = readPlist("./blued.plist")

# print the content in a human readable forat
#pprint(pl)

# open the file where we write the registry information
f = open(filename, 'w')

# function which is used to do the byte swapping and insert commas
def convertToWinRep(s):
	return ",".join(map(str.__add__, s[-2::-2] ,s[-1::-2]))

print("> Convert the Link Keys and store them to btkeys.reg")
# header for the registry file
f.write("Windows Registry Editor Version 5.00")


# loop over all avialable Bluetooth 2.0 adapters
print("  Bluetooth 2.0:    "+str(len(pl["LinkKeys"].keys()))+ " Links keys found")
for adapter in pl["LinkKeys"].keys():
	f.write('\r\n\r\n[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\BTHPORT\\Parameters\\Keys\\'+adapter.replace("-","")+"]")

	# loop over all available devices of this adapter
	for device in pl["LinkKeys"][adapter].keys():
		f.write('\r\n"'+device.replace("-","")+'"=hex:'+ convertToWinRep(pl["LinkKeys"][adapter][device].data.encode("hex")))



# loop over all Bluetooth 4.0 LE adapters
print("  Bluetooth 4.0 LE: "+str(len(pl["SMPDistributionKeys"].keys()))+ " Links keys found")
for adapter in pl["SMPDistributionKeys"].keys():

	# loop over all available devices of this adapter
	for device in pl["SMPDistributionKeys"][adapter].keys():
		dev = '\r\n\r\n[HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\BTHPORT\\Parameters\\Keys\\'+adapter.replace("-","")+'\\'+device.replace("-","") +"]"
		
		# Lonk-Term Key (LTK)
		# 128-bit key used to generate the session key for an encrypted connection.
		dev += '\r\n"LTK"=hex:'+ convertToWinRep(pl["SMPDistributionKeys"][adapter][device]["LTK"].data.encode("hex"))
		
		#dev += '\r"KeyLength"=dword:00000000' # Don't know why this is zero when i pair my BT LE Mouse with windows.
		dev += '\r\n"KeyLength"=dword:'+ pl["SMPDistributionKeys"][adapter][device]["LTKLength"].data.encode("hex").rjust(8,'0')

		# Random Number (RAND):
		# 64-bit stored value used to identify the LTK. A new RAND is generated each time a unique LTK is distributed.
		dev += '\r\n"ERand"=hex(b):'+ convertToWinRep(pl["SMPDistributionKeys"][adapter][device]["RAND"].data.encode("hex"))

		# Encrypted Diversifier (EDIV)
		# 16-bit stored value used to identify the LTK. A new EDIV is generated each time a new LTK is distributed.
		dev += '\r\n"EDIV"=dword:'+ pl["SMPDistributionKeys"][adapter][device]["EDIV"].data.encode("hex").rjust(8,'0')

		# Identity Resolving Key (IRK)
		# 128-bit key used to generate and resolve random address.
		dev += '\r\n"IRK"=hex:'+ convertToWinRep(pl["SMPDistributionKeys"][adapter][device]["IRK"].data.encode("hex"))

		# Device Address
		# 48-bit Address of the connected device
		dev += '\r\n"Address"=hex(b):'+ convertToWinRep(pl["SMPDistributionKeys"][adapter][device]["Address"].data.encode("hex").rjust(16,'0'))

		# Don't know whats that, i'm using an Logitech MX Master, and this is written to the registry when i pair it to windows
		dev += '\r\n"AddressType"=dword:00000001'

		# Connection Signature Resolving Key (CSRK)
		# 128-bit key used to sign data and verify signatures on the receiving device.
		# Info: CSRK is not stored on the OSX side.
		# It seems to be a temporary key which is only needed during the first bundling of the devices. After that, only the LTK is used.

		f.write(dev)

f.close()
print("> Registry file generated and ready for import")



