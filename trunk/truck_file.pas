unit truck_file;

interface
uses
  Types, Classes, SysUtils,
  file_parser;

type
{------------------------------------------------------------------------}
  tmy_node = record
    id          : integer;
    x,y,z       : extended;
    options     : string;
    selected    : boolean;
    highlight   : boolean;
  end;
{------------------------------------------------------------------------}
  tmy_beam = record
    id_begin    : integer;
    id_end      : integer;
    options     : string;

    highlight   : boolean;
    selected    : boolean;
  end;
{------------------------------------------------------------------------}
  tmy_fileinfo = record
    id          : string;
    group_id    : integer;
    version     : string;
  end;
{------------------------------------------------------------------------}
  tmy_author = record
    author_type : string;
    id          : string;
    name        : string;
    email       : string;
  end;
{------------------------------------------------------------------------}
  tmy_truck = class (tobject)
    name        : string;
    fileformatversion : string;
    fileinfo    : tmy_fileinfo;

    nodes       : array of tmy_node;
    beams       : array of tmy_beam;
    authors     : array of tmy_author;

    function  num_nodes : integer;
    function  num_beams : integer;
    function  num_authors : integer;
    function  get_free_nodeid: integer;
    function  find_nodeid(aid : integer) : integer;
    function  beam_exist(node_id1, node_id2 : integer): boolean;
    function  first_selected_node : integer;
    function  num_selected_nodes : integer;
    function  num_hl_nodes : integer;

    procedure clear;
    procedure deselect_nodes;
    procedure deselect_beams;
    procedure clone_selected;
    procedure move_selected_node(dx, dy, dz: extended);
    function  add_node(ax, ay, az : extended; aselected : boolean): integer;
    procedure add_beam(node_id1, node_id2 : integer; aselected : boolean);
    procedure delete_node(array_id : integer);
    procedure delete_beam(array_id : integer);
    function  delete_beam_bynode(nodeid: integer) : boolean;
    procedure connect_sel_nodes(aselected : boolean);
    procedure set_selected_node(index : integer);
  end;
{------------------------------------------------------------------------}


procedure LoadFile(fname: string; var truck : tmy_truck);
procedure SaveFile(fname: string; var truck : tmy_truck);

implementation

procedure SaveFile(fname: string; var truck : tmy_truck);
begin

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
  sysutils.decimalseparator := ',';
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
      setlength(truck.authors, truck.num_authors+1);
      if not parser.end_line then
        truck.authors[truck.num_authors-1].author_type := parser.get_word;
      if not parser.end_line then
        truck.authors[truck.num_authors-1].id := parser.get_word;
      if not parser.end_line then
        truck.authors[truck.num_authors-1].name := parser.get_word;
      if not parser.end_line then
        truck.authors[truck.num_authors-1].email := parser.get_word;
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
            setlength(truck.nodes, truck.num_nodes+1);
            if not parser.end_line then
              truck.nodes[truck.num_nodes-1].id := strtoint(parser.get_word);

            if not parser.end_line then
              truck.nodes[truck.num_nodes-1].x := get_float;

            if not parser.end_line then
              truck.nodes[truck.num_nodes-1].y := get_float;

            if not parser.end_line then
              truck.nodes[truck.num_nodes-1].z := get_float;

            if not parser.end_line then
              truck.nodes[truck.num_nodes-1].options := parser.get_word(true);
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
            setlength(truck.beams, truck.num_beams+1);
            
            if not parser.end_line then
              truck.beams[truck.num_beams-1].id_begin :=strtoint(parser.get_word);

            if not parser.end_line then
              truck.beams[truck.num_beams-1].id_end :=strtoint(parser.get_word);

            if not parser.end_line then
              truck.beams[truck.num_beams-1].options := parser.get_word(true);
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

{ tmy_truck }

procedure tmy_truck.add_beam(node_id1, node_id2: integer; aselected: boolean);
var
  new_id : integer;
begin
  new_id := num_beams;
  setlength(beams, num_beams+1);
  beams[new_id].id_begin := node_id1;
  beams[new_id].id_end := node_id2;
  beams[new_id].options := '';
  beams[new_id].highlight := false;
  beams[new_id].selected := aselected;
end;

function tmy_truck.add_node(ax, ay, az: extended; aselected : boolean): integer;
begin
  setlength(nodes , num_nodes+1);
  nodes[num_nodes-1].id := get_free_nodeid;
  nodes[num_nodes-1].x := ax;
  nodes[num_nodes-1].y := ay;
  nodes[num_nodes-1].z := az;

  nodes[num_nodes-1].options := '';

  nodes[num_nodes-1].selected := aselected;
  nodes[num_nodes-1].highlight := false;
  result := num_nodes-1;
end;

function tmy_truck.beam_exist(node_id1, node_id2: integer): boolean;
var
  i : integer;
begin
  result := false;
  for i := 0 to num_beams - 1 do
    if ((beams[i].id_begin = node_id1) and (beams[i].id_end = node_id2)) or
       ((beams[i].id_begin = node_id2) and (beams[i].id_end = node_id1)) then begin
          result := true;
          exit;
    end;
end;

procedure tmy_truck.clear;
begin
  setlength(nodes, 0);
  setlength(beams, 0);
  setlength(authors, 0);
end;

procedure tmy_truck.clone_selected;
var
  i, new_id : integer;
begin
  for i := 0 to num_nodes - 1 do
    if nodes[i].selected then begin
      nodes[i].selected := false;
      setlength(nodes, num_nodes+1);
      new_id := num_nodes-1;
      nodes[new_id].id := get_free_nodeid;;
      nodes[new_id].x := nodes[i].x;
      nodes[new_id].y := nodes[i].y;
      nodes[new_id].z := nodes[i].z;
      nodes[new_id].options := nodes[i].options;
      nodes[new_id].selected := true;
      nodes[new_id].highlight := false;
    end;
end;

procedure tmy_truck.connect_sel_nodes(aselected: boolean);
  procedure connect_with_node(aid : integer);
  var
    j : integer;
  begin
    for j := aid+1 to num_nodes - 1 do
      if nodes[j].selected then
        if not beam_exist(nodes[aid].id, nodes[j].id) then
          add_beam(nodes[aid].id, nodes[j].id, aselected);
  end;

var
  i : integer;
begin
  for i := 0 to num_nodes - 1 do
    if nodes[i].selected then begin
      connect_with_node(i);
    end;
end;

procedure tmy_truck.delete_beam(array_id: integer);
var
  i : integer;
begin
  for i := array_id to num_beams - 2 do
    beams[i] := beams[i+1];
  setlength(beams, num_beams -1);
end;

function tmy_truck.delete_beam_bynode(nodeid: integer): boolean;
var
  i : integer;
begin
  result := false;
  for i := 0 to num_beams - 1 do
    if (beams[i].id_begin = nodeid) or (beams[i].id_end = nodeid)  then begin
      delete_beam(i);
      result := true;
      exit;
    end;
end;

procedure tmy_truck.delete_node(array_id: integer);
var
  i : integer;
  beam_del : boolean;
begin
  repeat
    beam_del := delete_beam_bynode(nodes[array_id].id);
  until not beam_del;
  for i := array_id to num_nodes - 2 do
    nodes[i] := nodes[i+1];
  setlength(nodes, num_nodes -1);
end;

procedure tmy_truck.deselect_beams;
var
  i : integer;
begin
  for i := 0 to num_beams - 1 do
    beams[i].selected := false;
end;

procedure tmy_truck.deselect_nodes;
var
  i : integer;
begin
  for i := 0 to num_nodes - 1 do
    nodes[i].selected := false;
end;

function tmy_truck.find_nodeid(aid: integer): integer;
var
  i : integer;
begin
  result := -1;
  for i := 0 to num_nodes - 1 do
    if nodes[i].id = aid then begin
      result := i;
      exit;
    end;
end;

function tmy_truck.first_selected_node: integer;
var
  i : integer;
begin
  result := -1;
  for i := 0 to num_nodes - 1 do
    if nodes[i].selected then
    begin
      result := i;
      exit;
    end;
end;

function tmy_truck.get_free_nodeid: integer;
begin
  result := 0;
  while find_nodeid(result) >= 0 do
    inc(result);
end;

procedure tmy_truck.move_selected_node(dx, dy, dz: extended);
var
  i : integer;
begin
  for i := 0 to num_nodes - 1 do
    if nodes[i].selected  then begin
      nodes[i].x := nodes[i].x + dx;
      nodes[i].y := nodes[i].y + dy;
      nodes[i].z := nodes[i].z + dz;
    end;
end;

function tmy_truck.num_authors: integer;
begin
  result := length(authors);
end;

function tmy_truck.num_beams: integer;
begin
  result := length(beams);
end;

function tmy_truck.num_hl_nodes: integer;
var
  i : integer;
begin
  result := 0;
  for i := 0 to num_nodes - 1 do
    if nodes[i].highlight then
      inc(result);
end;

function tmy_truck.num_nodes: integer;
begin
  result := length(nodes);
end;

function tmy_truck.num_selected_nodes: integer;
var
  i : integer;
begin
  result := 0;
  for i := 0 to num_nodes - 1 do
    if nodes[i].selected then
      inc(result);
end;

procedure tmy_truck.set_selected_node(index: integer);
begin
  nodes[index].selected := true;
end;

end.
