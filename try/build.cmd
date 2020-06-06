@echo off
heat dir staging -gg -ke -srd -cg STAGINGDIRECTORY -dr APPLICATIONROOTDIRECTORY -o staging.wxs
candle staging.wxs main.wxs -arch x64
light -ext WixUIExtension -b staging main.wixobj staging.wixobj -o installer.msi
