; 脚本用 Inno Setup 脚本向导 生成。
; 查阅文档获取创建 INNO SETUP 脚本文件的详细资料！

#define MyAppName "我的程序"
#define MyAppVersion "1.5"
#define MyAppPublisher "我的公司"
#define MyAppURL "http://www.example.com/"
#define MyAppExeName "MyProg.exe"

[Setup]
; 注意: AppId 的值是唯一识别这个程序的标志。
; 不要在其他程序中使用相同的 AppId 值。
; (在编译器中点击菜单“工具 -> 产生 GUID”可以产生一个新的 GUID)
AppId={{2A49A5FB-6214-4B31-A753-78CF130ACD02}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "default"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "psvince.dll"; Flags: dontcopy noencryption
Source: "psvince.dll"; DestDir: "{app}";

Source: "C:\Program Files (x86)\Inno Setup 5\Examples\MyProg.exe"; DestDir: "{app}"; Flags: ignoreversion
; 注意: 不要在任何共享的系统文件使用 "Flags: ignoreversion"
  
[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[code]
// 安装时判断xxx是否正在运行=====================================================================================================================================================
function IsModuleLoaded(modulename: AnsiString ):  Boolean;
external 'IsModuleLoaded@files:psvince.dll stdcall';

function InitializeSetup():boolean;
var
   IsAppRunning: boolean;
   IsAppRunning1: boolean;
    ResultStr: String;
  ResultCode: Integer;
begin
    Result := true;
// 第二步，安装时判断客户端是否正在运行
   begin
    Result:= true;//安装程序继续
    IsAppRunning:= IsModuleLoaded('MyProg.exe');
    IsAppRunning1:= IsModuleLoaded('MyProg1.exe');
    while IsAppRunning or IsAppRunning1 do
       begin
        if MsgBox('Detects that "MyProg" or "MyProg1" is running' #13#13 'You must close it first and then click "OK" to continue the installation, or you can "Cancel" out!', mbConfirmation, MB_OKCANCEL) = IDOK then
         begin
         IsAppRunning:= IsModuleLoaded('MyProg.exe')
         IsAppRunning1:= IsModuleLoaded('MyProg1.exe');
           //if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppName}_is1', 'UninstallString', ResultStr) then
    begin
      ResultStr := RemoveQuotes(ResultStr);
      Exec(ResultStr, '', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end
    result := true;
         end else begin
         IsAppRunning:= false;
         Result:= false;//安装程序退出
         Exit;
         end;
       end;
     end;
end;
//===============================================================================================================================================================================

// 卸载时判断xxx是否正在运行=====================================================================================================================================================
function IsModuleLoadedU(modulename: String ): Boolean;
external 'IsModuleLoaded@{app}\psvince.dll stdcall uninstallonly';
function InitializeUninstall(): Boolean;
var
  IsAppRunning: boolean;
  IsAppRunning1: boolean;
begin
  Result :=true;  //卸载程序继续
  IsAppRunning:= IsModuleLoadedU('MyProg.exe');
  IsAppRunning1:= IsModuleLoadedU('MyProg1.exe');
  while IsAppRunning or IsAppRunning1 do
  begin
    if Msgbox('Detects that MyProg or MyProg1 is running'  #13#13 'You must close it first and then click "OK" to continue uninstalling, or you can "Cancel" out!', mbConfirmation, MB_OKCANCEL) = IDOK then
    begin
      IsAppRunning:= IsModuleLoadedU('MyProg.exe');
      IsAppRunning1:= IsModuleLoadedU('MyProg1.exe');


      //Result :=true; //卸载程序继续
      //Result := MsgBox('叫号系统服务端卸载程序:' #13#13 '你确定要卸载该程序?',mbConfirmation, MB_YESNO) = idYes;
    end else begin
      Result :=false; //卸载程序退出
      Exit;
    end;
  end;
  UnloadDLL(ExpandConstant('{app}\psvince.dll'));
end;
//===============================================================================================================================================================================
