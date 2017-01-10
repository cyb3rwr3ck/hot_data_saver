# hot_data_saver
Simple wrapper programm written in pure basic for dumping system memory and other volatile stuff like logs and so on. There is a precompiled x64 exe available, otherwise compile it with purebasic 5.21. No Windows API calls are used so the freeware version should be fine. 

It currently collects the following information:
* full dump of system memory
* basic network info
* running processes
* logged in users
* remotely opened files
* network shares
* last 10 SYSTEM/SECURITY logs
* mounted devices
* environment variables
* clipboard content

External executables (and their sha256sum) needed - dated to 09.01.2017:

56de17f38fbe0e94e4f5d8eaa4f6bd0f19f22435465c580bb8f8cc24a9671d60  	
openports.exe

95929d46442af6beed922233774e195e5bdf363b5293e7b998ca796b43d663d3  	
pclip.exe

033b81744e0bd4219a4d698894b8403bb67b525c96049cbfef34677d4d6fc85c  	
psfile64.exe

e6901e8423da3e54bab25f7c90f60d3979bfa5bb61bcc46059662736253b8c72  	
pslist64.exe

fdadb6e15c52c41a31e3c22659dd490d5b616e017d1b1aa6070008ce09ed27ea  	
PsLoggedon64.exe

08a635a6e94423c6404215adfd60a5d48dd0743b0b8f6cea143f738d053d501e  	
psloglist.exe

1a72da70694b3e00a8511c5035934461fc17ec4bfe9e04ee95860ecf926fa08d  	
win64dd.exe

1871b1fc9ba82235ea9d24419db4f15764eda018d3b78e1aa8bc6298fa4b634c  	
win64dd.sys
 
Most of them are sysinternal tools. Due to copyright concerns I will not include them directly.
As the goal must be to leave the memory as untouched as possible the executables are not checked for integrety before or after the program run. Do this by hand after you have finished gathering the information. 


### Usage
* get the above tools and save them in a folder called "tools"
* move this folder and the HDS executable to a writeable USB Stick
* plug the usb stick into the system you want to examin. Start the HDS-executable from CMD. 
* It will ask you for a project prefix, type it in. 
* A folder will be created next to the exe, starting with your prefix. All output goes here. 
* Wait for HDS to finish
 
