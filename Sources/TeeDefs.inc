// TeeChart Pro Defines
// See modifiable User Options below ...

{$IFNDEF MSWINDOWS}
{$IFDEF WIN32}
{$DEFINE MSWINDOWS}
{$ENDIF}
{$ENDIF}

{$IFDEF ADRENOCHROME}
{$DEFINE CHROME}
{$ELSE}
{$H+}
{$ENDIF}

{.$DEFINE TEEBETA} // Enable to compile in "BETA" mode (About Box, etc)

{$IFDEF CLR}
{$DEFINE TEENOASM}   // ASM (Inline Assembler) not supported in .NET
{$DEFINE TEESAFECLR} // Force "Safe" managed code only.

{$IFNDEF CHROME}
{$FINITEFLOAT OFF}   // Turn off floating-point exceptions to speed performance
{$ENDIF}

{$ENDIF}

{$DEFINE TEEVCL}  // Internal. Do not undefine TEEVCL !

{$DEFINE TEEEDITORS}

{$IFDEF TEELITEEMB}
{$DEFINE TEELITE}  // Embarcadero version 
{$ENDIF}

{$IFDEF FPC}
{$MODE DELPHI}
{$DEFINE D7}
{$DEFINE D6}
{$DEFINE D5}
{$DEFINE D4}
{$DEFINE D3}
{$IFNDEF FMX}
{$DEFINE LCL}
{$ENDIF}
{$ENDIF}

{$IFDEF LCL}
  {$DEFINE D3}
  {$DEFINE D4}
{$ENDIF}

{$IFDEF CPUX64}
{$DEFINE TEENOASM}   // Mixed ASM (Inline Assembler) not supported in x64

{$IFNDEF FPC}
{$EXCESSPRECISION OFF}  // Disable asm x64 Single to Double intermediate values
{$ENDIF}

{$ENDIF}

{$IFDEF FPC} // XE2
{$DEFINE TEENOASM}   // No ASM (Inline Assembler) for FreePascal
{$ENDIF}

{$IFDEF IOS} // XE3.5
{$DEFINE TEENOASM}   // No ASM (Inline Assembler) in iOS
{$ENDIF}

{$IFDEF ANDROID} // XE5
{$DEFINE TEENOASM}   // No ASM (Inline Assembler) in Android
{$ENDIF}

{$IFDEF VER370}  // RAD Studio XE v13.0 Florence 2025
  {$DEFINE D3}
  {$DEFINE D4}
  {$DEFINE D5}
  {$DEFINE D6}
  {$DEFINE D7}
  {$DEFINE D8}
  {$DEFINE D9}
  {$DEFINE D10}
  {$DEFINE D105}
  {$DEFINE D11}
  {$DEFINE D12}
  {$DEFINE D14}
  {$DEFINE D15}
  {$DEFINE D16}
  {$DEFINE D17}
  {$DEFINE D18}
  {$DEFINE D19}
  {$DEFINE D20}
  {$DEFINE D21}
  {$DEFINE D22}
  {$DEFINE D23}
  {$DEFINE D24}
  {$DEFINE D25}
  {$DEFINE D26}
  {$DEFINE D27}
  {$DEFINE D28}
  {$DEFINE D29}
  {$DEFINE D37}
{$ELSE}
  {$I TeeDefinesLegacy.inc}
{$ENDIF}

{$IFDEF D25}
{$WARN EXPLICIT_STRING_CAST OFF} // W1059
{$WARN EXPLICIT_STRING_CAST_LOSS OFF} // W1060
{$WARN LOST_EXTENDED_PRECISION OFF} // W1066 x64 only
{$WARN IMPLICIT_INTEGER_CAST_LOSS OFF} // W1071
{$WARN IMPLICIT_CONVERSION_LOSS OFF} // W1072
{$ENDIF}

{$IFDEF DECLARE_GPL}
{$DEFINE KYLIXOPEN}
{$ENDIF}

{$IFDEF BCB}
{$ObjExportAll On}
{$ENDIF}

{$IFDEF VER110}
  'Error: This TeeChart version does not support Delphi 4. Please use TeeChart version 7.'
{$ENDIF}

{$IFDEF VER100}
  'Error: This TeeChart version does not support Delphi 3. Please use TeeChart version 5.'
{$ENDIF}

{$IFDEF VER80}
  'Error: This TeeChart version does not support Delphi 1 and 2. Please use TeeChart version 4.'
{$ENDIF}

{$IFDEF UCL}
{$DEFINE CLX}
{$ENDIF}

{$IFDEF LINUX}
{$IFDEF FPC}
{$DEFINE FPCLINUX}
{$ELSE}
{$DEFINE CLX}
{$DEFINE FMXLINUX}
{$ENDIF}
{$ENDIF}

{$IFDEF D7}
{$IFNDEF K3}
{$IFNDEF FPC}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

{$IFDEF D6} 
{$WARN UNIT_PLATFORM OFF}   // Hide unit platform warnings
{$WARN SYMBOL_PLATFORM OFF} // Hide symbol platform warnings (streaming read/write)
{$ENDIF}

// User Options
// =====================

{$IFDEF CHROME}
{$UNDEF D9}
{$ENDIF}

{$IFDEF D9}
{$INLINE ON}  // Enable or disable inlining in Delphi 9
{$ENDIF}

{$IFDEF CPUX64}
{$DEFINE NOUSE_BDE}  // BDE is not available in 64bit platform
{$ENDIF}

{$IFDEF D21}
{$DEFINE NOUSE_BDE}  // BDE is not available in XE7 and up (Win32 & Win64)
{$ENDIF}

{$IFDEF NOTEEDB}
{$DEFINE NOUSE_BDE}  // BDE is not available in all ides "Starter" or "Personal" editions
{$ENDIF}

{.$DEFINE NOUSE_BDE}      // <-- remove the "." to avoid using the BDE (in QRChart, etc)
{.$DEFINE TEEMULTIPLIER}  // <-- remove the "." to enable obsolete "Multiplier" property,                           //     (slower performance)

{$IFDEF D5}
{.$DEFINE TEEENTERPRISE}  // <-- remove the "." to add ADO support in TeeChart Wizard
{$ENDIF}

{$IFNDEF TEEVALUESINGLE}
{$IFNDEF TEEVALUEEXTENDED}

// "Value" type for point values data.
// Remove the "." on ONLY one of the items below:

{$DEFINE TEEVALUEDOUBLE}
{.$DEFINE TEEVALUESINGLE}
{.$DEFINE TEEVALUEEXTENDED}

{$ENDIF}
{$ENDIF}

// Unicode support from D6 and up,
// but not for BCB6 due to overload ambiguity. Not for CLX.
{$IFDEF BCB}
 {$IFDEF D10}
   {$DEFINE TEEUNICODE}
 {$ENDIF}
{$ELSE}
 {$IFNDEF CLR}
  {$IFDEF D6}
   {$DEFINE TEEUNICODE}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFNDEF FMX}
{$IFNDEF TEELITE}
{$IFNDEF FPC}
{$DEFINE TEEEXCEPTIONS}  // Send design-time exceptions to steema.com
{$ENDIF}
{$ENDIF}

{$IFDEF MSWINDOWS}
{$DEFINE USEWINDOWS}
{$ENDIF}

{$IFDEF OSX}
{$DEFINE USEWINDOWS} // CrossVCL.com
{$ENDIF}

{$ENDIF}

{$IFDEF D18}
{$IFDEF IOS}
{$DEFINE TEELISTMETA} // QC115377
{$ENDIF}
{$IFDEF ANDROID}
{$DEFINE TEELISTMETA} // QC115377
{$DEFINE TEENOPRINT}
{$ENDIF}
{$IFDEF LINUX}
{$DEFINE TEELISTMETA} // QC115377
{$ENDIF}
{$ENDIF}

