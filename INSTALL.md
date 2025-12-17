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

If yes, then you should look at [Sources\Packages\Pro](https://github.com/Steema/TeeTree/tree/main/Sources/Packages/Pro) folder for the appropiate packages for your RAD Studio version.

If not, then the [Sources\Packages\Lite](https://github.com/Steema/TeeTree/tree/main/Sources/Packages/Lite) folder contains the packages that should be compiled and installed.
These use the free TeeChart version (VCL and FMX) included in Delphi / C++ RAD Studio ide.

### Steps to build the Lite version:
   
1) Open this file with RAD Studio: [Sources\Packages\Lite\TeeTree_Lite.groupproj](https://github.com/Steema/TeeTree/tree/main/Sources/Packages/Lite)
2) Right-click the DclVCL package and click "Install"
3) Right-click the DclFMX package and click "Install" (for Firemonkey)

<img width="422" height="300" alt="image" src="https://github.com/user-attachments/assets/2e4ecfbf-269f-4841-bffb-c946bacc450b" />

Optional: Install the free [TeeChart Lite update for RAD 13.0 Florence](https://www.steema.com/files/public/teechart/vcl/TeeChart_Lite_RAD13_Patch_251209.7z)  

### Using TeeTree

Create a new VCL Application, you should see the TTree component at the Component Palette:

<img width="1813" height="1498" alt="image" src="https://github.com/user-attachments/assets/752b2ec7-e249-4e53-a4b2-302403d1cab1" />

### The same in Firemonkey

<img width="913" height="664" alt="image" src="https://github.com/user-attachments/assets/d294b89c-bec5-405a-9242-89618ee33b01" />

### Compiling

1) Please add the paths to TeeTree sources at Delphi global Tools -> Options -> Language -> Delphi -> Library (Win32, Win64, etc), and / or to your:

Project -> Options -> Building -> Delphi Compiler -> Search Path

<img width="1261" height="861" alt="image" src="https://github.com/user-attachments/assets/7815ce7f-7188-4dba-9da6-fdd49d0898b7" />

   
2) Add the VclTee and FMXTee namespace prefixes

<img width="375" height="611" alt="image" src="https://github.com/user-attachments/assets/7513b8dc-c761-4a92-b5b9-f15bf8aa5f6c" />



