unit utils;

interface

uses
  Windows, Types, Classes, SysUtils;

function currpath: string;
function mousePos:Tpoint;

implementation

function mousePos:Tpoint;
begin getCursorPos(result) end;

function currpath: string;
begin
  Result := extractfiledir(paramstr(0));
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + PathDelim;
end;


end.
