; �ű��� Inno Setup �ű��� ���ɡ�
; �����ĵ���ȡ���� INNO SETUP �ű��ļ�����ϸ���ϣ�

#define MyAppName "�ҵĳ���"
#define MyAppVersion "1.5"
#define MyAppPublisher "�ҵĹ�˾"
#define MyAppURL "http://www.example.com/"
#define MyAppExeName "MyProg.exe"

[Setup]
; ע��: AppId ��ֵ��Ψһʶ���������ı�־��
; ��Ҫ������������ʹ����ͬ�� AppId ֵ��
; (�ڱ������е���˵������� -> ���� GUID�����Բ���һ���µ� GUID)
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
; ע��: ��Ҫ���κι����ϵͳ�ļ�ʹ�� "Flags: ignoreversion"
  
[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[code]
// ��װʱ�ж�xxx�Ƿ���������=====================================================================================================================================================
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
// �ڶ�������װʱ�жϿͻ����Ƿ���������
   begin
    Result:= true;//��װ�������
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
         Result:= false;//��װ�����˳�
         Exit;
         end;
       end;
     end;
end;
//===============================================================================================================================================================================

// ж��ʱ�ж�xxx�Ƿ���������=====================================================================================================================================================
function IsModuleLoadedU(modulename: String ): Boolean;
external 'IsModuleLoaded@{app}\psvince.dll stdcall uninstallonly';
function InitializeUninstall(): Boolean;
var
  IsAppRunning: boolean;
  IsAppRunning1: boolean;
begin
  Result :=true;  //ж�س������
  IsAppRunning:= IsModuleLoadedU('MyProg.exe');
  IsAppRunning1:= IsModuleLoadedU('MyProg1.exe');
  while IsAppRunning or IsAppRunning1 do
  begin
    if Msgbox('Detects that MyProg or MyProg1 is running'  #13#13 'You must close it first and then click "OK" to continue uninstalling, or you can "Cancel" out!', mbConfirmation, MB_OKCANCEL) = IDOK then
    begin
      IsAppRunning:= IsModuleLoadedU('MyProg.exe');
      IsAppRunning1:= IsModuleLoadedU('MyProg1.exe');


      //Result :=true; //ж�س������
      //Result := MsgBox('�к�ϵͳ�����ж�س���:' #13#13 '��ȷ��Ҫж�ظó���?',mbConfirmation, MB_YESNO) = idYes;
    end else begin
      Result :=false; //ж�س����˳�
      Exit;
    end;
  end;
  UnloadDLL(ExpandConstant('{app}\psvince.dll'));
end;
//===============================================================================================================================================================================
