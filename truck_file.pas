unit truck_file;

interface
uses
  Forms, Messages, Windows, Types, Classes, SysUtils,
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
  tmy_hydro = record
    id_begin    : integer;
    id_end      : integer;
    factor      : extended;
    options     : string;

    highlight   : boolean;
    selected    : boolean;
  end;
{------------------------------------------------------------------------}
  tmy_shock = record
    id_begin    : integer;
    id_end      : integer;
    spring      : integer;
    damping     : integer;
    shortbound  : extended;
    longbound   : extended;
    precompression : extended;

    options     : string;

    highlight   : boolean;
    selected    : boolean;
  end;
{------------------------------------------------------------------------}
  tmy_command = record
    id_begin    : integer;
    id_end      : integer;
    rate        : extended;
    short       : extended;
    long        : extended;

    key_short   : integer;
    key_long    : integer;

    options     : string;
    desc        : string;
    
    highlight   : boolean;
    selected    : boolean;
  end;
{------------------------------------------------------------------------}
  tmy_fileinfo = record
    id          : string;
    group_id    : string;
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
  tmy_globals = record
    dry_mass    : string;
    cargo_mass  : string;
    material    : string;
  end;
{------------------------------------------------------------------------}
  tmy_truck = class (tobject)
    // FIELDS
    name        : string;
    fileformatversion : string;
    fileinfo    : tmy_fileinfo;
    globals     : tmy_globals;
    description : tstringlist;
    help        : string;

    nodes       : array of tmy_node;
    beams       : array of tmy_beam;
    hydros      : array of tmy_hydro;
    shocks      : array of tmy_shock;
    commands    : array of tmy_command;
    authors     : array of tmy_author;
    camera      : array [1..3] of integer;

    // FUNCTIONS (GET STATE)
    function  num_nodes : integer;
    function  num_beams : integer;
    function  num_hydros : integer;
    function  num_shocks : integer;
    function  num_commands : integer;
    function  num_authors : integer;
    function  get_free_nodeid: integer;
    function  find_nodeid(aid : integer) : integer;
    function  beam_exist(node_id1, node_id2 : integer): boolean;
    function  node_exist(node_id: integer): boolean;
    function  beam_invisible(id : integer) : boolean;
    function  first_selected_node : integer;
    function  num_selected_nodes : integer;
    function  num_hl_nodes : integer;
    function  cameras_exist: boolean;
    function  globals_correct : boolean;

    // PROCEDURES (ACTIONS)
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

    // OBJECT
    constructor create;
    destructor  destroy; override;
  end;
{------------------------------------------------------------------------}


procedure LoadFile(fname: string; var truck : tmy_truck);
procedure SaveFile(fname: string; var truck : tmy_truck);
function  IsTruckCorrect(var truck : tmy_truck) : boolean;

implementation

function  IsTruckCorrect(var truck : tmy_truck) : boolean;
begin
  result := (truck.num_nodes > 0)
    and (truck.num_beams > 0)
    and (truck.cameras_exist)
    and (truck.globals_correct);
end;

procedure SaveFile(fname: string; var truck : tmy_truck);
var
  F : textfile;
  i : integer;

  procedure write_float(value : extended);
  begin
    write(F,
      strreplace(
        FloattoStrF(value,
          ffFixed,
          18,
          6),
        ',','.'
      )
    );
  end;

  procedure write_str(value : string);
  begin
    write(F, value);
  end;

  procedure write_eol;
  begin
    write(F, #13#10);
  end;

  procedure write_div;
  begin
    write_str(', ');
  end;
//==============================================================================
begin
  if not IsTruckCorrect(truck) then begin
    Application.MessageBox('Truck is not correct','Save error', MB_OK+MB_ICONERROR);
    exit;
  end;
{==============================================================================}
  if fileexists(fname) then
    if not deletefile(fname) then
      begin
        Application.MessageBox('Cant delete exists file','Save error', MB_OK+MB_ICONERROR);
        exit;
      end;
{==============================================================================}
// BEGIN FILE
  assignfile(F, fname);
  rewrite(F);
  
{==============================================================================}
// NAME
  write_str(Truck.name);
  write_eol;
  write_str(';generated by truckeditor2 (c) arksu');
  write_eol;
  write_eol;

{==============================================================================}
// FILEFORMATVERSION
  if truck.fileformatversion <> '' then begin
    write_str('fileformatversion '+truck.fileformatversion);
    write_eol;
    write_eol;
  end;

{==============================================================================}
// DESCRIPTION
  if truck.description.Count > 0 then begin
    write_str('description'); write_eol;
    for i := 0 to truck.description.Count - 1 do begin
      write_str(truck.description[i]); write_eol;
    end;
    write_str('end_description'); write_eol;
    write_eol;
  end;
{==============================================================================}
// FILEINFO
  write_str('fileinfo ');
  write_str(truck.fileinfo.id);                 write_div;
  write_str(truck.fileinfo.group_id); write_div;
  write_str(truck.fileinfo.version);            write_eol;
  write_eol;

{==============================================================================}
// GLOBALS
  writeln(F, 'globals');
  write_str(truck.globals.dry_mass);      write_div;
  write_str(truck.globals.cargo_mass);    write_div;
  write_str(truck.globals.material);      write_eol;
  write_eol;
  
{==============================================================================}
// AUTHORS
  for i := 0 to truck.num_authors - 1 do begin
    write_str('author');
    write_str(' '+truck.authors[i].author_type);
    write_str(' '+truck.authors[i].id);
    write_str(' '+truck.authors[i].name);
    if truck.authors[i].email <> '' then begin
      write_str(' '+truck.authors[i].email);
      write_eol
    end else write_eol;
  end;
  write_eol;
  
{==============================================================================}
// CAMERAS
  write_str('cameras'); write_eol;
  write_str(inttostr(truck.camera[1])); write_div;
  write_str(inttostr(truck.camera[2])); write_div;
  write_str(inttostr(truck.camera[3])); write_eol;
  write_eol;
  
{==============================================================================}
// NODES
  write_str('nodes'); write_eol;
  for i := 0 to truck.num_nodes - 1 do
    with truck.nodes[i] do begin
      write_str(inttostr(id)); write_div;
      write_float(x); write_div;
      write_float(y); write_div;
      write_float(z);
      if options <> '' then begin
        write_div;
        write_str(options);
        write_eol;
      end else write_eol;
    end;
  write_eol;

{==============================================================================}
// BEAMS
  write_str('beams'); write_eol;
  for i := 0 to truck.num_beams - 1 do
    with truck.beams[i] do begin
      write_str(inttostr(id_begin)); write_div;
      write_str(inttostr(id_end));
      if options <> '' then begin
        write_div;
        write_str(options);
        write_eol;
      end else write_eol;
    end;
  write_eol;
  
{==============================================================================}
  write_eol;
  write_str('end');
  write_eol;
  closefile(F);
end;

procedure LoadFile(fname: string; var truck : tmy_truck);
var
  line, word : string;
  parser : tstr_parser;

  function read_float : extended;
  begin
    result := strtofloat(StrReplace(parser.get_word, '.', ','));
  end;

  function read_int : integer;
  begin
    result := strtoint(parser.get_word);
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

    // FILE FORMAT VERSION =========================
    if word = 'fileformatversion' then
      truck.fileformatversion := parser.get_word(true);
    // =============================================

    // FILE INFO ===================================
    if word = 'fileinfo' then begin
      if not parser.end_line then truck.fileinfo.id := parser.get_word;
      if not parser.end_line then truck.fileinfo.group_id := parser.get_word;
      if not parser.end_line then truck.fileinfo.version := parser.get_word;
    end;
    // =============================================

    // AUTHOR ======================================
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
    // =============================================

    // NODES ===========================
    if line = 'nodes' then begin
      parser.next_line;
      line := parser.get_line;
      
      while (
        (pos(',',line)>0) or (line='')
        or (pos(';',line)>0)
        ) do begin
        if (
          (pos(';',line) <= 0) and (length(line)>4)
          and (pos('set_beam_defaults',line)<=0)
          ) then begin
            setlength(truck.nodes, truck.num_nodes+1);

            // ======================
            with truck.nodes[truck.num_nodes-1] do begin
            selected := false;
            highlight := false;
            options := '';
            
            if not parser.end_line then
              id := read_int;

            if not parser.end_line then
              x := read_float;

            if not parser.end_line then
              y := read_float;

            if not parser.end_line then
              z := read_float;

            if not parser.end_line then
              options := parser.get_word(true);
            end; // end with =========
        end;
        parser.next_line;
        line := parser.get_line;
      end;
      parser.prev_line;
    end;
    //=======================================

    // BEAMS ===========================
    if line = 'beams' then begin
      parser.next_line;
      line := parser.get_line;
      while ( (pos(',',line)>0) or (line='') or (pos(';',line)>0)) do begin
        if (pos(';',line) <= 0) and (length(line)>4) and (pos('set_beam_defaults', line)<=0) then begin
            setlength(truck.beams, truck.num_beams+1);

            //========================
            with truck.beams[truck.num_beams-1] do begin
            selected := false;
            highlight := false;
            options := '';
            
            if not parser.end_line then
              id_begin := read_int;

            if not parser.end_line then
              id_end := read_int;

            if not parser.end_line then
              options := parser.get_word(true);
            end; // end with ==========
        end;
        parser.next_line;
        line := parser.get_line;
      end;
      parser.prev_line;
    end;
    //============================

    // HYDROS ===========================
    if line = 'hydros' then begin
      parser.next_line;
      line := parser.get_line;
      while ( (pos(',',line)>0) or (line='') or (pos(';',line)>0)) do begin
        if (pos(';',line) <= 0) and (length(line)>4) and (pos('set_beam_defaults', line)<=0) then begin
            setlength(truck.hydros, truck.num_hydros+1);

            //===========================
            with truck.hydros[truck.num_hydros-1] do begin
            selected := false;
            highlight := false;
            options := '';
            
            if not parser.end_line then
              id_begin := read_int;

            if not parser.end_line then
              id_end := read_int;

            if not parser.end_line then
              factor := read_float;

            if not parser.end_line then
              options := parser.get_word(true);
            end; // end with =============
        end;
        parser.next_line;
        line := parser.get_line;
      end;
      parser.prev_line;
    end;
    //============================

    // SHOCKS ===========================
    if line = 'shocks' then begin
      parser.next_line;
      line := parser.get_line;
      while ( (pos(',',line)>0) or (line='') or (pos(';',line)>0)) do begin
        if (pos(';',line) <= 0) and (length(line)>4) and (pos('set_beam_defaults', line)<=0) then begin
            setlength(truck.shocks, truck.num_shocks+1);

            //===========================
            with truck.shocks[truck.num_shocks-1] do begin
            selected := false;
            highlight := false;
            options := '';
            
            if not parser.end_line then
              id_begin := read_int;

            if not parser.end_line then
              id_end := read_int;

            if not parser.end_line then
              spring := read_int;

            if not parser.end_line then
              damping := read_int;

            if not parser.end_line then
              shortbound := read_float;

            if not parser.end_line then
              longbound := read_float;

            if not parser.end_line then
              precompression := read_float;

            if not parser.end_line then
              options := parser.get_word(true);
            end; // end with =============
        end;
        parser.next_line;
        line := parser.get_line;
      end;
      parser.prev_line;
    end;
    //============================

    // COMMANDS ===========================
    if line = 'commands' then begin
      parser.next_line;
      line := parser.get_line;
      while ( (pos(',',line)>0) or (line='') or (pos(';',line)>0)) do begin
        if (pos(';',line) <= 0) and (length(line)>4) and (pos('set_beam_defaults', line)<=0) then begin
            setlength(truck.commands, truck.num_commands+1);

            //========================
            with truck.commands[truck.num_commands-1] do begin
            selected := false;
            highlight := false;
            options := '';

            if not parser.end_line then
              id_begin := read_int;

            if not parser.end_line then
              id_end := read_int;
            if not parser.end_line then
              rate := read_float;
            if not parser.end_line then
              short := read_float;
            if not parser.end_line then
              long := read_float;
            if not parser.end_line then
              key_short := read_int;
            if not parser.end_line then
              key_long := read_int;

            if not parser.end_line then
              options := parser.get_word;

            if not parser.end_line then
              desc := parser.get_word(true);
            end; // end with ==========
        end;
        parser.next_line;
        line := parser.get_line;
      end;
      parser.prev_line;
    end;
    //============================

    // CAMERA =============================
    if line = 'cameras' then begin
      parser.next_line;
      line := parser.get_line;
      while (pos(';',line)>0) or (length(line) < 5) do begin
         parser.next_line;
         line := parser.get_line;
      end;

      if not parser.end_line then
        truck.camera[1] := strtoint(parser.get_word);
      if not parser.end_line then
        truck.camera[2] := strtoint(parser.get_word);
      if not parser.end_line then
        truck.camera[3] := strtoint(parser.get_word);
    end;
    //============================

    // GLOBALS ==============================
    if line = 'globals' then begin
      parser.next_line;
      line := parser.get_line;
      while (pos(';',line)>0) or (length(line) < 5) do begin
         parser.next_line;
         line := parser.get_line;
      end;

      if not parser.end_line then
        truck.globals.dry_mass  := parser.get_word;
      if not parser.end_line then
        truck.globals.cargo_mass := parser.get_word;
      if not parser.end_line then
        truck.globals.material := parser.get_word(true);
    end;
    //======================================

    // DESCRIPTION ===================================================
    if line = 'description' then begin
      parser.next_line;
      line := parser.get_line;
      while (line <> 'end_description') and (not parser.end_file) do begin
        truck.description.Add(line);
        parser.next_line;
        line := parser.get_line;
      end;
    end;
    //===================================================

    // COMMENTS ===================================================
    if line = 'comment' then begin
      repeat
        parser.next_line;
        line := parser.get_line;
      until (line = 'end_comment') or (parser.end_file);
    end;
    //===================================================

    // HELP ===================================================
    if line = 'help' then begin
      parser.next_line;
      truck.help := parser.get_line;
    end;
    //===================================================

    // END FILE =================================
    if line = 'end' then break;    
    //===================================================
    parser.next_line;
  end; // end main loop
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

function tmy_truck.beam_invisible(id: integer): boolean;
begin
  result := pos('i', beams[id].options) > 0;
end;

function tmy_truck.cameras_exist: boolean;
begin
  result := (node_exist(camera[1]))  and
            (node_exist(camera[2]))  and
            (node_exist(camera[3]))  and
            (camera[1] <> camera[2]) and
            (camera[1] <> camera[3]) and
            (camera[2] <> camera[3]);
end;

procedure tmy_truck.clear;
begin
  setlength(nodes,   0);
  setlength(beams,   0);
  setlength(hydros,  0);
  setlength(shocks,  0);
  setlength(authors, 0);
  description.Clear;
  globals.dry_mass := '0';
  globals.cargo_mass := '0';
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

constructor tmy_truck.create;
begin
  description := tstringlist.Create;
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

destructor tmy_truck.destroy;
begin
  description.Free;
  inherited;
end;

function tmy_truck.find_nodeid(aid: integer): integer;
var
  i : integer;
begin
  for i := 0 to num_nodes - 1 do
    if nodes[i].id = aid then begin
      result := i;
      exit;
    end;
  result := -1;
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

function tmy_truck.globals_correct: boolean;
begin
  result := (globals.dry_mass <> '')
    and (globals.cargo_mass <> '')
    and (globals.material <> '');
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

function tmy_truck.node_exist(node_id: integer): boolean;
begin
  result := find_nodeid(node_id) <> -1;
end;

function tmy_truck.num_authors: integer;
begin
  result := length(authors);
end;

function tmy_truck.num_beams: integer;
begin
  result := length(beams);
end;

function tmy_truck.num_commands: integer;
begin
  result := length(commands);
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

function tmy_truck.num_hydros: integer;
begin
  result := length(hydros);
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

function tmy_truck.num_shocks: integer;
begin
  result := length(shocks);
end;

procedure tmy_truck.set_selected_node(index: integer);
begin
  nodes[index].selected := true;
end;

end.
