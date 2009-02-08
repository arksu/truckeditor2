unit file_parser;

interface
uses
  Classes;

type
  tstr_parser = class
    lines : tstringlist;
    cur_line, cur_pos : integer;

    constructor create;
    destructor destroy; override;

    procedure clear;
    procedure load_file(fname :string);

    // �������� ������� �����
    function get_word(to_end : boolean = false) : string;
    // �������� ������� ����� � ������� �� ���������
    function get_line : string;
    // �������� �� ����� �����
    function end_line : boolean;
    // ������� �� �������� ������
    procedure next_line;
    procedure prev_line;
    // ����� ������� ������
    function cur_length : integer;
    // ��������� �� ����� �����
    function end_file : boolean;
  end;

function StrReplace(const Str, Str1, Str2: string): string;

implementation

function StrReplace(const Str, Str1, Str2: string): string;
// str - �������� ������
// str1 - ���������, ���������� ������
// str2 - ���������� ������
var
  P, L: Integer;
begin
  Result := str;
  L := Length(Str1);
  repeat
    P := Pos(Str1, Result); // ���� ���������
    if P > 0 then
    begin
      Delete(Result, P, L); // ������� ��
      Insert(Str2, Result, P); // ��������� �����
    end;
  until P = 0;
end;

{ tstr_parser }

procedure tstr_parser.clear;
begin
  lines.Clear;
  cur_line := 0;
  cur_pos := 1;
end;

constructor tstr_parser.create;
begin
  lines := tstringlist.Create;
end;

function tstr_parser.cur_length: integer;
begin
  if cur_line < lines.Count then
    result := length(lines[cur_line])
  else
    result := 0;
end;

destructor tstr_parser.destroy;
begin
  lines.Free;
  inherited;
end;

function tstr_parser.end_file: boolean;
begin
  result := cur_line >= lines.Count;
end;

function tstr_parser.end_line: boolean;
begin
  if cur_line < lines.Count then
    result := cur_pos > length(lines[cur_line])
  else result := true;
end;

function tstr_parser.get_line: string;
begin
  result := '';
  if cur_line >= lines.Count then exit;
  result := lines[cur_line];
end;

function tstr_parser.get_word(to_end : boolean = false): string;
var
  s : string;
  ch : char;
  word : boolean;
begin
  // �������� ������
  s := lines[cur_line];

  result := '';
  word := false;
  while cur_pos <= cur_length do
  begin
    ch := s[cur_pos];
    inc(cur_pos);

    // ���� ����� ����������� - �������
    if not to_end then
    if ch = ',' then break;

    // ���������� ������� ����� ������
    if ((ch =#32) or (ch=#9)) and (not word) then continue;

    if not to_end then
    if ((ch =#32) or (ch=#9)) and (word) then break;

    result := result + ch;
    word := true;
  end;

end;

procedure tstr_parser.load_file(fname: string);
begin
  lines.LoadFromFile(fname);
end;

procedure tstr_parser.next_line;
begin
  inc(cur_line);
  cur_pos := 1;
end;

procedure tstr_parser.prev_line;
begin
  dec(cur_line);
  cur_pos := 1;
end;

end.
