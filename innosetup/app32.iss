[Setup]
AppName=Valor Launcher
AppPublisher=Valor
UninstallDisplayName=Valor
AppVersion=${project.version}
AppSupportURL=https://zaryte.io/
DefaultDirName={localappdata}\Valor

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\Valor.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=ValorSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\build\win-x86\Valor.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\Valor.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\launcher_x86.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"

[Icons]
; start menu
Name: "{userprograms}\Valor\Valor"; Filename: "{app}\Valor.exe"
Name: "{userprograms}\Valor\Valor (configure)"; Filename: "{app}\Valor.exe"; Parameters: "--configure"
Name: "{userprograms}\Valor\Valor (safe mode)"; Filename: "{app}\Valor.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\Valor"; Filename: "{app}\Valor.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\Valor.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Valor.exe"; Description: "&Open Valor"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\Valor.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.valor\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"