unit HookKey_Unit;

interface
 uses windows,messages;
const
  WM_HOOKKEY = WM_USER + $1000;
  procedure HookOn; stdcall;
  procedure HookOff;  stdcall;
implementation
var
  HookDeTeclado     : HHook;
  FileMapHandle     : THandle;
  PViewInteger      : ^Integer;

function CallBackDelHook( Code    : Integer;
                          wParam  : WPARAM;
                          lParam  : LPARAM
                          )       : LRESULT; stdcall;

begin
   if code=HC_ACTION then
   begin
    FileMapHandle:=OpenFileMapping(FILE_MAP_READ,False,'TestHook');
    if FileMapHandle<>0 then
    begin
      PViewInteger:=MapViewOfFile(FileMapHandle,FILE_MAP_READ,0,0,0);
      PostMessage(PViewInteger^,WM_HOOKKEY,wParam,lParam);
      UnmapViewOfFile(PViewInteger);
      CloseHandle(FileMapHandle);
    end;
  end;
  Result := CallNextHookEx(HookDeTeclado, Code, wParam, lParam)
end;

procedure HookOn; stdcall;
begin
  HookDeTeclado:=SetWindowsHookEx(WH_KEYBOARD, CallBackDelHook, HInstance , 0);
end;

procedure HookOff;  stdcall;
begin
  UnhookWindowsHookEx(HookDeTeclado);
end;


end.       
