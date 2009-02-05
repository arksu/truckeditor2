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

    // получить текущее слово
    function get_word(to_end : boolean = false) : string;
    // получить текущую линию и перейти на следующую
    function get_line : string;
    // достигли ли конца линии
    function end_line : boolean;
    // перейти на следущую строку
    procedure next_line;
    procedure prev_line;
    // длина текущей строки
    function cur_length : integer;
    // достигнут ли конец файла
    function end_file : boolean;
  end;

function StrReplace(const Str, Str1, Str2: string): string;

implementation

function StrReplace(const Str, Str1, Str2: string): string;
// str - исходная строка
// str1 - подстрока, подлежащая замене
// str2 - заменяющая строка
var
  P, L: Integer;
begin
  Result := str;
  L := Length(Str1);
  repeat
    P := Pos(Str1, Result); // ищем подстроку
    if P > 0 then
    begin
      Delete(Result, P, L); // удаляем ее
      Insert(Str2, Result, P); // вставляем новую
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
  // получаем строку
  s := lines[cur_line];

  result := '';
  word := false;
  while cur_pos <= cur_length do
  begin
    ch := s[cur_pos];
    inc(cur_pos);

    // если нашли разделитель - выходим
    if not to_end then
    if ch = ',' then break;

    // пропускаем пробелы перед словом
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
