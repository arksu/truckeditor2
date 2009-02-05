unit truck_file;

interface
uses
  Types, Classes, SysUtils,
  file_parser;

type
  tmy_node = record
    id : integer;
    x,y,z : extended;
    options : string;
    selected : boolean;
    highlight : boolean;
  end;

  tmy_beam = record
    id_begin, id_end : integer;
    options : string;
  end;

  tmy_fileinfo = record
    id : string;
    group_id : integer;
    version : string;
  end;

  tmy_author = record
    author_type : string;
    id : string;
    name : string;
    email : string;
  end;

  tmy_truck = record
    name : string;
    fileformatversion : string;
    fileinfo : tmy_fileinfo;

    nodes : array of tmy_node;
    beams  : array of tmy_beam;
    authors : array of tmy_author;
  end;


procedure LoadFile(fname: string; var truck : tmy_truck);
function num_authors(truck : tmy_truck): integer;
function num_beams(truck : tmy_truck): integer;
function num_nodes(truck : tmy_truck): integer;

implementation

function num_authors(truck : tmy_truck): integer;
begin
  result := length(truck.authors);
end;

function num_beams(truck : tmy_truck): integer;
begin
  result := length(truck.beams);
end;

function num_nodes(truck : tmy_truck): integer;
begin
  result := length(truck.nodes);
end;

procedure LoadFile(fname: string; var truck : tmy_truck);
var
  line, word : string;
  parser : tstr_parser;
  
  function get_float : extended;
  begin
    result := strtofloat(StrReplace(parser.get_word, '.', ','));
  end;

begin
  parser := tstr_parser.create;
  parser.Clear;
  parser.load_file(fname);

  truck.name := parser.get_line; parser.next_line;

  while not parser.end_file do
  begin
    line := parser.get_line;
    word := parser.get_word;

    // FILE FORMAT VERSION
    if word = 'fileformatversion' then
      truck.fileformatversion := parser.get_word(true);

    // FILE INFO
    if word = 'fileinfo' then begin
      if not parser.end_line then truck.fileinfo.id := parser.get_word;
      if not parser.end_line then truck.fileinfo.group_id := strtoint(parser.get_word);
      if not parser.end_line then truck.fileinfo.version := parser.get_word;
    end;

    // AUTHOR
    if word = 'author' then begin
      setlength(truck.authors, num_authors(truck)+1);
      if not parser.end_line then
        truck.authors[num_authors(truck)-1].author_type := parser.get_word;
      if not parser.end_line then
        truck.authors[num_authors(truck)-1].id := parser.get_word;
      if not parser.end_line then
        truck.authors[num_authors(truck)-1].name := parser.get_word;
      if not parser.end_line then
        truck.authors[num_authors(truck)-1].email := parser.get_word;
    end;

    // NODES===========================
    if line = 'nodes' then begin
      parser.next_line;
      line := parser.get_line;
      while (
        (pos(',',line)>0) or (line='')
        or (pos(';',line)>0)
//        or (pos('set_beam_defaults',line)<=0)
        ) do begin
        if (
          (pos(';',line) <= 0) and (length(line)>4)
          and (pos('set_beam_defaults',line)<=0)
          ) then begin
            setlength(truck.nodes, num_nodes(truck)+1);
            if not parser.end_line then
              truck.nodes[num_nodes(truck)-1].id := strtoint(parser.get_word);

            if not parser.end_line then
              truck.nodes[num_nodes(truck)-1].x := get_float;

            if not parser.end_line then
              truck.nodes[num_nodes(truck)-1].y := get_float;

            if not parser.end_line then
              truck.nodes[num_nodes(truck)-1].z := get_float;

            if not parser.end_line then
              truck.nodes[num_nodes(truck)-1].options := parser.get_word(true);
        end;
        parser.next_line;
        line := parser.get_line;
      end;
    end;
    //=======================================

    // BEAMS===========================
    if line = 'beams' then begin
      parser.next_line;
      line := parser.get_line;
      while ( (pos(',',line)>0) or (line='') or (pos(';',line)>0)) do begin
        if (pos(';',line) <= 0) and (length(line)>4) and (pos('set_beam_defaults', line)<=0) then begin
            setlength(truck.beams, num_beams(truck)+1);
            
            if not parser.end_line then
              truck.beams[num_beams(truck)-1].id_begin :=strtoint(parser.get_word);

            if not parser.end_line then
              truck.beams[num_beams(truck)-1].id_end :=strtoint(parser.get_word);

            if not parser.end_line then
              truck.beams[num_beams(truck)-1].options := parser.get_word(true);            
        end;
        parser.next_line;
        line := parser.get_line;
      end;
    end;
    //============================

    
    parser.next_line;
  end;
  parser.free;  
end;

end.
