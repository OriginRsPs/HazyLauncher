[Setup]
AppName=Hazy Launcher
AppPublisher=Hazy
UninstallDisplayName=Hazy
AppVersion=${project.version}
AppSupportURL=https://zaryte.io/
DefaultDirName={localappdata}\Hazy

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\Hazy.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=HazySetup

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\Hazy.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\Hazy.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\launcher_amd64.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Hazy\Hazy"; Filename: "{app}\Hazy.exe"
Name: "{userprograms}\Hazy\Hazy (configure)"; Filename: "{app}\Hazy.exe"; Parameters: "--configure"
Name: "{userprograms}\Hazy\Hazy (safe mode)"; Filename: "{app}\Hazy.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\Hazy"; Filename: "{app}\Hazy.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\Hazy.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Hazy.exe"; Description: "&Open Hazy"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\Hazy.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.hazy\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"