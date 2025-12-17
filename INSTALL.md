## TeeTree Installation

The Packages folder contains all runtime and design-time packages to install TeeTree at design-time in the IDE.

It is not mandatory to install, you can also use TeeTree by code, as usually with any other control:

```delphi

uses TeeTree; // <-- or FMXTee.Tree for Firemonkey
var Tree1 : TTree;
Tree1 := TTree.Create(Self);
Tree1.Parent := Self;
```

### Do you have TeeChart Pro?

If yes, then you should look at Packages\Pro folder for the appropiate packages for your RAD Studio version.

If not, then the Packages\Lite folder contains the packages that should be compiled and installed.
These use the free TeeChart version (VCL and FMX) included in Delphi / C++ RAD Studio ide.

### Steps to build the Lite version:

1) Install the free TeeChart Lite update for RAD 13.0 Florence. This update includes files necessary for TeeTree.
2) Run RAD 13 and open this file: Sources\Packages\Lite\TeeTree_Lite.groupproj
3) Right-click the DclVCL package and click "Install"
4) Right-click the DclFMX package and click "Install"

<img width="422" height="300" alt="image" src="https://github.com/user-attachments/assets/2e4ecfbf-269f-4841-bffb-c946bacc450b" />

   
### Using TeeTree

Create a new VCL Application, you should see the TTree component at the Component Palette:

<img width="1813" height="1498" alt="image" src="https://github.com/user-attachments/assets/752b2ec7-e249-4e53-a4b2-302403d1cab1" />

### The same in Firemonkey

<img width="913" height="664" alt="image" src="https://github.com/user-attachments/assets/d294b89c-bec5-405a-9242-89618ee33b01" />


