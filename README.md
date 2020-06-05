# Learning the WIX Toolset



It is based on Windows Installer <https://docs.microsoft.com/en-us/windows/win32/msi>. WIX is based on compile, link, and build. The source code for WIX is `.wxs`. You can compile using `candle.exe`, link and build `.msi` using `light.exe`.



## WIX Source Code Structure

The `.wxs` is composed of XML Elements and is structured like this.

1. Wix
   1. Product
   2. Package
   3. Media
   4. Property
   5. Directory
      1. Directory
         1. Component
            1. File
               1. Shortcut
            2. RemoveFolder
            3. RegistryValue
   6. DirectoryRef
   7. Feature
      1. ComponentRef
   8. Icon

Each xml element have `Id` property. There is also `GUID` for the `Product` element and each `Component` element. There is also a `GUID` for the `UpgradeCode` property of the `Product` element.

Basic properties you need to set.

1. Name - in the Product element.
2. Manufacturer - in the Product element.
3. Version - in the Product element.
4. Description - in the Package element.

The `Feature` element contains all `Id` of `Component`. The Feature element describes what to install. You can have many Feature element, and only have few to install. You can also have Feature element that contains all Components.

You can define the directory structure in the `Directory` element inside the `Product` element with the `Id="TARGETDIR"` property. And add the files inside `DirectoryRef` element right after the `Directory` element with `Id="TARGETDIR"` property.



## Basic Example of WIX Source Code

Below is a sample `.wxs` file.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
    <Product Id="*" UpgradeCode="PUT-GUID-HERE" Version="1.0.0.0" Language="1033" Name="My Application Name" Manufacturer="My Manufacturer Name">
        <Package InstallerVersion="300" Compressed="yes"/>
        <Media Id="1" Cabinet="myapplication.cab" EmbedCab="yes" />

        <!-- Step 1: Define the directory structure -->
        <Directory Id="TARGETDIR" Name="SourceDir">
            <Directory Id="ProgramFilesFolder">
                <Directory Id="APPLICATIONROOTDIRECTORY" Name="My Application Name"/>
            </Directory>
        </Directory>

        <!-- Step 2: Add files to your installer package -->
        <DirectoryRef Id="APPLICATIONROOTDIRECTORY">
            <Component Id="myapplication.exe" Guid="PUT-GUID-HERE">
                <File Id="myapplication.exe" Source="MySourceFiles\MyApplication.exe" KeyPath="yes" Checksum="yes"/>
            </Component>
            <Component Id="documentation.html" Guid="PUT-GUID-HERE">
                <File Id="documentation.html" Source="MySourceFiles\documentation.html" KeyPath="yes"/>
            </Component>
        </DirectoryRef>

        <!-- Step 3: Tell WiX to install the files -->
        <Feature Id="MainApplication" Title="Main Application" Level="1">
            <ComponentRef Id="myapplication.exe" />
            <ComponentRef Id="documentation.html" />
        </Feature>
    </Product>
</Wix>
```



## Heat

The `heat.exe` is a program that is used to automatically generate `.wxs` file from a directory structure. Example below.

```bash
heat dir <directory> -gg -cg <component group name> -o <name>.wxs
```

The Component Group is the name that can be linked to the main `.wxs` file inside the `Feature` element.

