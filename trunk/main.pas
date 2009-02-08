unit main;

interface
{
  номера нод
  колеса
  шоки
  командные грани
}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, OpenGL, AppEvnts, Menus, IniFiles, Buttons, ComCtrls,
  StdCtrls,

  utils, gl_font, truck_file;

type
  tmy_vector = record x, y, z : extended; end;
  
  tmy_drag = (MD_NONE, MD_MOVE, MD_ROTATE, MD_SCALE);
  tmy_move_mode = (MM_XY, MM_XZ, MM_ZY);
  tmy_glcolor = array [1..3] of extended;

  tmy_camera = record
      Rot_X, Rot_Y : Single;
      Scale : Single;
      pos_x, pos_y, pos_z : single;
  end;

  tviewport_type = (vt_free, vt_left, vt_front, vt_top);

  Tmy_viewport = record
    DC            : HDC;
    RC            : HGLRC;
    Camera        : tmy_camera;
    view_type     : tviewport_type;
    mdrag         : tmy_drag;
    Mpos          : TPoint;
    panel         : TPanel;

    procedure init_gl;
    procedure init_cam;

    procedure finit_gl;
  end;

  Teditor_form = class(TForm)
{$region 'systems'}
    main_panel: TPanel;
    menu_panel: TPanel;
    main_view: TPanel;
    front_view: TPanel;
    left_view: TPanel;
    top_view: TPanel;
    Splitter1: TSplitter;
    ApplicationEvents1: TApplicationEvents;
    od: TOpenDialog;
    sd: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Clear1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    View1: TMenuItem;
    Axis1: TMenuItem;
    N2: TMenuItem;
    Front1: TMenuItem;
    op1: TMenuItem;
    Left1: TMenuItem;
    mode_view: TSpeedButton;
    mode_nodes: TSpeedButton;
    mode_beams: TSpeedButton;
    nodes_select: TSpeedButton;
    nodes_move: TSpeedButton;
    xy_btn: TSpeedButton;
    z_btn: TSpeedButton;
    Edit1: TMenuItem;
    grid_size_tb: TTrackBar;
    XY_move: TSpeedButton;
    XZ_move: TSpeedButton;
    ZY_move: TSpeedButton;
    custom_pages: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Gridsize1: TMenuItem;
    N10x101: TMenuItem;
    N50x501: TMenuItem;
    N100x1001: TMenuItem;
    N500x5001: TMenuItem;
    N1000x10001: TMenuItem;
    Snaptogrid1: TCheckBox;
    Grid1: TCheckBox;
    Label1: TLabel;
    Resetviewa1: TMenuItem;
    movex_btn: TSpeedButton;
    movey_btn: TSpeedButton;
    movez_btn: TSpeedButton;
    SpeedButton5: TSpeedButton;
    beams_select: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    beams_add: TSpeedButton;
    Rotate1: TMenuItem;
    N3: TMenuItem;
    rotate_timer: TTimer;
    nodes_add: TSpeedButton;
    Autoselectnewnodes1: TMenuItem;
    TabSheet2: TTabSheet;
    Shownodes1: TMenuItem;
    del_nodes: TSpeedButton;
    del_beams: TSpeedButton;
    Showbeams1: TMenuItem;
    Nodesnum1: TMenuItem;
    Addview1: TMenuItem;
    Free1: TMenuItem;
    Left2: TMenuItem;
    op2: TMenuItem;
    Front2: TMenuItem;
    procedure main_panelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure main_panelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure main_panelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure main_viewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure main_viewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure main_viewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Clear1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure left_viewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure left_viewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure left_viewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure front_viewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure top_viewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure front_viewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure top_viewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure front_viewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure top_viewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Axis1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Front1Click(Sender: TObject);
    procedure op1Click(Sender: TObject);
    procedure Left1Click(Sender: TObject);
    procedure Snaptogrid1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure N10x101Click(Sender: TObject);
    procedure N50x501Click(Sender: TObject);
    procedure N100x1001Click(Sender: TObject);
    procedure N500x5001Click(Sender: TObject);
    procedure N1000x10001Click(Sender: TObject);
    procedure grid_size_tbChange(Sender: TObject);
    procedure Resetviewa1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure rotate_timerTimer(Sender: TObject);
    procedure Autoselectnewnodes1Click(Sender: TObject);
    procedure Shownodes1Click(Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure del_nodesClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure beams_addClick(Sender: TObject);
    procedure mode_beamsClick(Sender: TObject);
    procedure del_beamsClick(Sender: TObject);
    procedure Showbeams1Click(Sender: TObject);
    procedure Nodesnum1Click(Sender: TObject);
{$endregion}
  private
    DC_main, DC_left, DC_front, DC_top : HDC;
    RC_main, RC_left, RC_front, RC_top : HGLRC;
    {---------------------------------------------}
    Camera_main,
    Camera_left,
    Camera_front,
    Camera_top        : tmy_camera;
    {---------------------------------------------}
    MDrag_main,
    Mdrag_left,
    mdrag_front,
    mdrag_top         : tmy_drag;
    {---------------------------------------------}
    MPos_main,
    mpos_left,
    mpos_front,
    mpos_top          : TPoint;
    {---------------------------------------------}
    old_panels_x      : integer;
    old_panels_y      : integer;
    main_downed       : boolean;
    {---------------------------------------------}
    // цвета
    back_color        : tmy_glcolor;
    beam_color        : tmy_glcolor;
    node_color        : tmy_glcolor;
    nodes_font_color  : tmy_glcolor;
    shock_color       : tmy_glcolor;
    command_color     : tmy_glcolor;
    grid_color        : tmy_glcolor;
    {---------------------------------------------}
    node_select_color : tmy_glcolor;
    node_hl_color     : tmy_glcolor;
    beam_select_color : tmy_glcolor;
    beam_hl_color     : tmy_glcolor;
    {---------------------------------------------}
    // радиус точки
    points_radius     : single;
    begin_rect        : tpoint;
    end_rect          : tpoint;
    panel_rect        : tpanel;
    opened_file       : string;
    {---------------------------------------------}
    old_point,
    grid_point,
    cur_add_node      : tmy_vector;
    {---------------------------------------------}
    nodes_font_main   : Tgl_font;
    nodes_font_top    : Tgl_font;
    nodes_font_left   : Tgl_font;
    nodes_font_front  : Tgl_font;
    nodes_num_prefix  : string;

    procedure set_color(strcolor : string; var gl_color : tmy_glcolor);
    procedure init_cams;
  public
    truck             : tmy_truck;
    views             : array of tmy_viewport;

    procedure add_view(atype : tviewport_type; apanel : tpanel);

    procedure init;
    procedure read_params; // прочитать параметры из ини файла
    procedure write_params; // записать параметры в ини файл
    procedure set_panels(x,y : integer); // обновить размеры проекций
    procedure ClearAll; // очистить все ресурсы

    procedure redner_all;
    procedure render_mesh;
    procedure render_view(aDC: HDC;
        aRC : HGLRC;
        aview : tpanel;
        acamera : tmy_camera);
    procedure render_select_frame;
    procedure render_nodes_num(aDC: HDC; aRC: HGLRC; aview: tpanel;
  acamera: tmy_camera);

    procedure update_nodes(aview :tpanel);
    procedure update_add_nodes(aview :tpanel);
    procedure update_rect_nodes;
    procedure update_beams_select(aview :tpanel);

    function  to_grid(value : extended) : extended;
  end;
  
const
  FORM_CAPTION      = 'Truck editor';
  PANELS_OFFSET     = 2; // зазор между панелями видов
  AXIS_LENGTH       = 20; // длина осей
  COMMENT_CHAR      = ';'; // символ комментария

  // коэффициенты камеры
  ROTATE_K          = 0.3; // вращение
  SCALE_K           = 0.1;  // масштаб
  MOVE_K            = 0.9;   // перемещение

  GRID_STEP_K       = 0.1; // множитель для создания сетки (умножается на значение ползунка)
  HIGHLIGHT_K       = 0.1; // размер осей вокруг подсвеченной ноды

  NODE_SELECT_RANGE = 5; // размер квадрата вокруг ноды для выбора в виде
  BEAM_SELECT_RANGE = 3; // диапазон по вертикали для выбора ребра

var
  editor_form: Teditor_form;


implementation

{$R *.dfm}

procedure Teditor_form.add_view(atype: tviewport_type; apanel : tpanel);
begin
  setlength(views, length(views) + 1);
  views[length(views)-1].view_type := atype;
  views[length(views)-1].panel := apanel;
end;

procedure Teditor_form.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if windowstate = wsMinimized then exit;
  if not application.Active then exit;
  
  redner_all;
  Done := False;
end;

procedure Teditor_form.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  // < ESCAPE > - exit programm
  if Msg.CharCode = VK_ESCAPE then begin
    handled := true;
    close;
  end;

  // < DELETE > - delete nodes
  if msg.CharCode = VK_DELETE then begin
    handled := true;
    del_nodes.Click;
  end;

  // < B > - connect nodes for create beams
  if msg.CharCode = 66 then begin
    handled := true;
    truck.connect_sel_nodes(Autoselectnewnodes1.Checked);
  end;
end;

procedure Teditor_form.Autoselectnewnodes1Click(Sender: TObject);
begin
  Autoselectnewnodes1.Checked := not Autoselectnewnodes1.Checked;
end;

procedure Teditor_form.Axis1Click(Sender: TObject);
begin
  Axis1.Checked := not Axis1.Checked;
end;

procedure Teditor_form.beams_addClick(Sender: TObject);
begin
  truck.deselect_nodes;
end;

procedure Teditor_form.Clear1Click(Sender: TObject);
begin
  ClearAll;
end;

procedure Teditor_form.ClearAll;
begin
  caption := FORM_CAPTION;
  truck.name := '';
  opened_file := '';
  truck.clear;
end;

procedure Teditor_form.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure Teditor_form.render_mesh;
  function GetPoint(ID: Integer): Integer;
  var
    j : Integer;
  begin
    for j := 0 to Length(truck.nodes) - 1 do
      if truck.nodes[j].id = ID then
      begin
        Result := j;
        Exit;
      end;
    Result := 0;
  end;
var
  i : integer;
begin
{==============================================================================}
// AXIS
  if Axis1.Checked then begin
  glLineWidth(1);
  glBegin(GL_LINES);
    glColor3f(1, 0, 0);
      glVertex3f(0, 0, 0);
      glVertex3f(AXIS_LENGTH, 0, 0);
    glColor3f(0, 1, 0);
      glVertex3f(0, 0, 0);
      glVertex3f(0, AXIS_LENGTH, 0);
    glColor3f(0, 0, 1);
      glVertex3f(0, 0, 0);
      glVertex3f(0, 0, AXIS_LENGTH);
  glEnd;
  end;

{==============================================================================}
// BEAMS
  if Showbeams1.Checked then begin
  for i := 0 to Length(truck.beams) - 1 do
      with truck.beams[i] do
      begin
        // HL
        if truck.beams[i].highlight then begin
          glColor3f(beam_hl_color[1],beam_hl_color[2],beam_hl_color[3]);
          glLineWidth(3);
        // SELECT
        end else if truck.beams[i].selected then begin
          glColor3f(beam_select_color[1],beam_select_color[2],beam_select_color[3]);
          glLineWidth(3);
        // NORMAL
        end else begin
          glColor3f(beam_color[1], beam_color[2], beam_color[3]);
          glLineWidth(1);
        end;

        glBegin(GL_LINES);
        with truck.nodes[GetPoint(id_begin)] do
          glVertex3f(x, y, z);
        with truck.nodes[GetPoint(id_end)] do
          glVertex3f(x, y, z);
        glEnd;
      end;
  end;

{==============================================================================}
// NODES
  if Shownodes1.Checked then begin
  glEnable(GL_POINT_SMOOTH);
  for i := 0 to Length(truck.nodes) - 1 do
    with truck.nodes[i] do begin
        if selected then begin
        // SELECTED
          glColor3f(node_select_color[1], node_select_color[2], node_select_color[3]);
          glPointSize(6);
        end else
        if highlight then begin
        // HIGHLIGHT
          glColor3f(1, 0, 0);
          glBegin(GL_LINES);
            glVertex3f(x-HIGHLIGHT_K, y, z);
            glVertex3f(x+HIGHLIGHT_K, y, z);
            glVertex3f(x, y-HIGHLIGHT_K, z);
            glVertex3f(x, y+HIGHLIGHT_K, z);
            glVertex3f(x, y, z-HIGHLIGHT_K);
            glVertex3f(x, y, z+HIGHLIGHT_K);
          glEnd;
          glColor3f(node_hl_color[1], node_hl_color[2], node_hl_color[3]);
          glPointSize(6);
        end else begin
          glPointSize(points_radius);
          glColor3f(node_color[1], node_color[2], node_color[3]);
        end;
        glBegin(GL_POINTS);

        glVertex3f(x, y, z);
        glEnd;
    end;
  end;
{==============================================================================}
  // highlight new ndoe
  if 
  (nodes_add.Down) and (mode_nodes.Down) then
  with cur_add_node do begin
          glColor3f(1, 0, 0);
          glBegin(GL_LINES);
            glVertex3f(x-HIGHLIGHT_K, y, z);
            glVertex3f(x+HIGHLIGHT_K, y, z);
            glVertex3f(x, y-HIGHLIGHT_K, z);
            glVertex3f(x, y+HIGHLIGHT_K, z);
            glVertex3f(x, y, z-HIGHLIGHT_K);
            glVertex3f(x, y, z+HIGHLIGHT_K);
          glEnd;

          glEnable(GL_POINT_SMOOTH);
          glBegin(GL_POINTS);
            glColor3f(0, 1, 1);
            glPointSize(6);
            glVertex3f(x, y, z);
          glEnd;
  end;
  // highlight new beam
  if (beams_add.Down) and (mode_beams.Down) and (truck.num_selected_nodes = 1) and (truck.num_hl_nodes = 1) then begin
        glColor3f(beam_hl_color[1],beam_hl_color[2],beam_hl_color[3]);
        glLineWidth(3);
        glBegin(GL_LINES);
        for i := 0 to truck.num_nodes - 1 do
        if truck.nodes[i].selected then
          with truck.nodes[i] do begin
            glVertex3f(x, y, z);
            break;
          end;
        for i := 0 to truck.num_nodes - 1 do
        if truck.nodes[i].highlight then
          with truck.nodes[i] do begin
            glVertex3f(x, y, z);
            break;
          end;
        glEnd;
  end;
{==============================================================================}
end;

procedure Teditor_form.render_nodes_num(aDC: HDC; aRC: HGLRC; aview: tpanel;
  acamera: tmy_camera);
var
  i : integer;
  Viewport : Array [0..3] of GLInt;
  mvMatrix, ProjMatrix : Array [0..15] of GLDouble;
  wx, wy, wz : GLdouble;
begin

  for i := 0 to truck.num_nodes - 1 do begin

    //nodes_font.Init;
    glColor3f(nodes_font_color[1],nodes_font_color[2],nodes_font_color[3]);
//    nodes_font.Print(round(wx), aview.Height - round(wy), 'nd_'+inttostr(truck.nodes[i].id));
{    if aview = main_view then begin
      if not nodes_font.inited then nodes_font.init;

    nodes_font.Print(
                      truck.nodes[i].x,
                      truck.nodes[i].y,
                      truck.nodes[i].z,
                      nodes_num_prefix+inttostr(truck.nodes[i].id)
                    );
    end;       }
    //nodes_font.Free;
  end;
end;

procedure Teditor_form.render_select_frame;
begin
  if panel_rect = nil then exit;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho(0,panel_rect.Width, panel_rect.Height,0, -1, 1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  glColor3f(0.3, 0.3, 0.3);
  glBegin(GL_LINES);
    glVertex2f(begin_rect.X, begin_rect.Y);
    glVertex2f(end_rect.X, begin_rect.Y);

    glVertex2f(end_rect.X, begin_rect.Y);
    glVertex2f(end_rect.X, end_rect.Y);

    glVertex2f(end_rect.X, end_rect.Y);
    glVertex2f(begin_rect.X, end_rect.Y);

    glVertex2f(begin_rect.X, end_rect.Y);
    glVertex2f(begin_rect.X, begin_rect.Y);
  glEnd;
end;

procedure Teditor_form.main_viewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  case Button of
    mbLeft  : begin
      if mode_view.Down then MDrag_main := MD_MOVE;
    end;
    mbRight : MDrag_main := MD_ROTATE;
    mbMiddle : MDrag_main := MD_SCALE;
  end;
  MPos_main := Point(X, Y);

  // NODES SELECT
  if (button=mbleft) and (mode_nodes.Down) and (nodes_select.Down) then begin
    begin_rect := point(X, Y);
    end_rect := point(X, Y);
    if not (ssCtrl in Shift) then truck.deselect_nodes;
    for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].selected and truck.nodes[i].highlight then begin
        truck.nodes[i].selected := false;
        break;
      end;
      if truck.nodes[i].highlight then begin
        truck.set_selected_node(i);
        break;
      end;
    end;
  end;

  // NODES MOVE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    old_point.x := truck.nodes[truck.first_selected_node].x;
    old_point.y := truck.nodes[truck.first_selected_node].y;
    old_point.z := truck.nodes[truck.first_selected_node].z;

    grid_point := old_point;
  end;

  // BEAMS SELECT
  if (button=mbleft) and (mode_beams.Down) and (beams_select.Down) then begin
    if not (ssCtrl in Shift) then truck.deselect_beams;
    for i := 0 to truck.num_beams - 1 do begin
      if truck.beams[i].selected and truck.beams[i].highlight then begin
        truck.beams[i].selected := false;
        break;
      end;
      if truck.beams[i].highlight then begin
        truck.beams[i].selected := true;
        break;
      end;
    end;
  end;

  // BEAMS ADD
  if (button=mbleft) and (mode_beams.Down) and (beams_add.Down) then begin
    if truck.num_selected_nodes > 2 then begin
      truck.deselect_nodes;
      exit;
    end;
    if truck.num_selected_nodes <=1 then
      for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].highlight then begin
        truck.nodes[i].selected := true;
        break;
        end;
      end;
    if truck.num_selected_nodes = 2 then begin
      truck.connect_sel_nodes(Autoselectnewnodes1.Checked);
      truck.deselect_nodes;
    end;
  end;
end;

procedure Teditor_form.main_viewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  dx,dy,dz : extended;
  cur_point, cur_grid : tmy_vector;
begin
   case MDrag_main of
    MD_ROTATE :
      begin
        Camera_main.Rot_X := Camera_main.Rot_X - (Y - MPos_main.Y) * ROTATE_K;
        Camera_main.Rot_Y := Camera_main.Rot_Y - (X - MPos_main.X) * ROTATE_K;
      end;
    MD_SCALE  :
      Camera_main.Scale := Camera_main.Scale - (Y - MPos_main.Y) * SCALE_K;
    MD_MOVE:
      begin
        if xy_btn.Down then begin
            Camera_main.pos_x := Camera_main.pos_x - (Y - MPos_main.Y) * MOVE_K / Camera_main.Scale;
            Camera_main.pos_z := Camera_main.pos_z - (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
        end;
        if z_btn.Down then begin
            Camera_main.pos_y := Camera_main.pos_y + (Y - MPos_main.Y) * MOVE_K / Camera_main.Scale;
        end;
      end;
  end;

  // NODES SELECT
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_select.Down) then begin
    end_rect := point(X, Y);
    panel_rect := main_view;
  end;

  // NODES MOVE
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    if XY_move.Down then begin
      dx := (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
      dy := -(Y - MPos_main.Y) * MOVE_K / Camera_main.Scale;
      dz := 0;
    end;
    if XZ_move.Down then begin
      dx := (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
      dz := (Y - MPos_main.Y) * MOVE_K / Camera_main.Scale;
      dy := 0;
    end;
    if ZY_move.Down then begin
      dz := (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
      dy := -(Y - MPos_main.Y) * MOVE_K / Camera_main.Scale;
      dx := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - MPos_main.X) * MOVE_K / Camera_main.Scale;
      dy := 0;
      dx := 0;
    end;

    // old_point , grid_point;
    cur_point.x := old_point.x + dx;
    cur_point.y := old_point.y + dy;
    cur_point.z := old_point.z + dz;

    cur_grid.x := to_grid(cur_point.x);
    cur_grid.y := to_grid(cur_point.y);
    cur_grid.z := to_grid(cur_point.z);

    truck.move_selected_node(
      cur_grid.x - grid_point.x,
      cur_grid.y - grid_point.y,
      cur_grid.z - grid_point.z
    );
   old_point := cur_point;
   grid_point := cur_grid;

  end;
  
  MPos_main := Point(X, Y);
// ограничения всякие
  if Camera_main.Rot_X > 90 then
    Camera_main.Rot_X := 90;
  if Camera_main.Rot_X < -90 then
    Camera_main.Rot_X := -90;
  if Camera_main.Scale < 0.1 then
    Camera_main.Scale := 1;
end;

procedure Teditor_form.main_viewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  MDrag_main := MD_NONE;
  panel_rect := nil;

  if (mode_nodes.Down) and (nodes_select.Down) then
  for i := 0 to truck.num_nodes - 1 do
    if truck.nodes[i].highlight then begin
      truck.nodes[i].highlight := false;
      truck.nodes[i].selected := true;
    end; 
end;

procedure Teditor_form.mode_beamsClick(Sender: TObject);
begin
  truck.deselect_nodes;
end;

procedure Teditor_form.N1000x10001Click(Sender: TObject);
begin
  N1000x10001.Checked := true;
end;

procedure Teditor_form.N100x1001Click(Sender: TObject);
begin
  N100x1001.Checked := true;
end;

procedure Teditor_form.N10x101Click(Sender: TObject);
begin
  N10x101.Checked := true;
end;

procedure Teditor_form.N500x5001Click(Sender: TObject);
begin
  N500x5001.Checked := true;
end;

procedure Teditor_form.N50x501Click(Sender: TObject);
begin
  N50x501.Checked := true;
end;

procedure Teditor_form.Nodesnum1Click(Sender: TObject);
begin
  Nodesnum1.Checked := not Nodesnum1.Checked;
end;

procedure Teditor_form.op1Click(Sender: TObject);
begin
  Camera_main.Rot_X := 90;
  Camera_main.Rot_Y := 0;
end;

procedure Teditor_form.FormCreate(Sender: TObject);
var
  pfd : TPixelFormatDescriptor;
begin
  read_params;
  caption := FORM_CAPTION;
  
// Creating window
  DC_main   := GetDC(main_view.Handle);
  DC_left   := GetDC(left_view.Handle);
  DC_front  := GetDC(front_view.Handle);
  DC_top    := GetDC(top_view.Handle);
// OpenGL initialization
  FillChar(pfd, SizeOf(pfd), 0);
  with pfd do
  begin
    nSize        := SizeOf(pfd);
    nVersion     := 1;
    dwFlags      := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
    cColorBits   := 32;
    cDepthBits   := 24;
    cStencilBits := 8;
  end;

  SetPixelFormat(DC_main,  ChoosePixelFormat(DC_main, @pfd), @pfd);
  SetPixelFormat(DC_left,  ChoosePixelFormat(DC_main, @pfd), @pfd);
  SetPixelFormat(DC_front, ChoosePixelFormat(DC_main, @pfd), @pfd);
  SetPixelFormat(DC_top,   ChoosePixelFormat(DC_main, @pfd), @pfd);

  RC_main   := wglCreateContext(DC_main);
  RC_left   := wglCreateContext(DC_left);
  RC_front  := wglCreateContext(DC_front);
  RC_top    := wglCreateContext(DC_top);

  init;
// всякие начальные параметры

  SetLength(truck.nodes, 2);
  truck.nodes[0].id := 10;
  truck.nodes[0].x := 10;
  truck.nodes[0].y := 10;
  truck.nodes[0].z := 10;
  truck.nodes[1].id := 20;
  truck.nodes[1].x := 1;
  truck.nodes[1].y := 1;
  truck.nodes[1].z := 1;

  SetLength(truck.beams, 1);
  truck.beams[0].id_begin := 10;
  truck.beams[0].id_end   := 20;

end;

procedure Teditor_form.FormDestroy(Sender: TObject);
begin
  write_params;
  ClearAll;
//  nodes_font.Free;
  wglMakeCurrent(0,0);
  
  wglDeleteContext(RC_main);
  ReleaseDC(main_view.Handle,DC_main);
  DeleteDC(DC_main);

  wglDeleteContext(RC_left);
  ReleaseDC(left_view.Handle,DC_left);
  DeleteDC(DC_left);

  wglDeleteContext(RC_front);
  ReleaseDC(front_view.Handle,DC_front);
  DeleteDC(DC_front);

  wglDeleteContext(RC_top);
  ReleaseDC(top_view.Handle,DC_top);
  DeleteDC(DC_top);
end;

procedure Teditor_form.FormResize(Sender: TObject);
begin
  set_panels(old_panels_x, old_panels_y);
end;

procedure Teditor_form.Grid1Click(Sender: TObject);
begin
  Grid1.Checked := not Grid1.Checked;
end;

procedure Teditor_form.grid_size_tbChange(Sender: TObject);
begin
  label1.Caption := 'Cell size: '+floattostr(GRID_STEP_K * grid_size_tb.Position);
end;

procedure Teditor_form.Front1Click(Sender: TObject);
begin
  Camera_main.Rot_X := 0;
  Camera_main.Rot_Y := 90;
end;

procedure Teditor_form.front_viewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  case Button of
    mbRight  : begin
      MDrag_front := MD_MOVE;
    end;
    //mbRight : MDrag_front := MD_ROTATE;
    mbMiddle : MDrag_front := MD_SCALE;
  end;
  MPos_front := Point(X, Y);

  if (button=mbleft) and (mode_nodes.Down) and (nodes_select.Down) then begin
    begin_rect := point(X, Y);
    end_rect := point(X, Y);
    if not (ssCtrl in Shift) then truck.deselect_nodes;
    for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].selected and truck.nodes[i].highlight then begin
        truck.nodes[i].selected := false;
        break;
      end;
      if truck.nodes[i].highlight then begin
        truck.set_selected_node(i);
        break;
      end;

    end;
  end;
  // NODES MOVE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    old_point.x := truck.nodes[truck.first_selected_node].x;
    old_point.y := truck.nodes[truck.first_selected_node].y;
    old_point.z := truck.nodes[truck.first_selected_node].z;

    grid_point := old_point;
  end;

  // NODES CREATE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_add.Down) then begin
    truck.add_node(cur_add_node.x, cur_add_node.y, cur_add_node.z, Autoselectnewnodes1.Checked);
  end;
  
  // BEAMS SELECT
  if (button=mbleft) and (mode_beams.Down) and (beams_select.Down) then begin
    if not (ssCtrl in Shift) then truck.deselect_beams;
    for i := 0 to truck.num_beams - 1 do begin
      if truck.beams[i].selected and truck.beams[i].highlight then begin
        truck.beams[i].selected := false;
        break;
      end;
      if truck.beams[i].highlight then begin
        truck.beams[i].selected := true;
        break;
      end;
    end;
  end;

  // BEAMS ADD
  if (button=mbleft) and (mode_beams.Down) and (beams_add.Down) then begin
    if truck.num_selected_nodes > 2 then begin
      truck.deselect_nodes;
      exit;
    end;
    if truck.num_selected_nodes <=1 then
      for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].highlight then begin
        truck.nodes[i].selected := true;
        break;
        end;
      end;
    if truck.num_selected_nodes = 2 then begin
      truck.connect_sel_nodes(Autoselectnewnodes1.Checked);
      truck.deselect_nodes;
    end;
  end;
end;

procedure Teditor_form.front_viewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx,dy,dz : extended;
  cur_point, cur_grid : tmy_vector;
begin
   case MDrag_front of
    MD_ROTATE :
      begin 
        Camera_front.Rot_X := Camera_front.Rot_X - (Y - MPos_front.Y) * ROTATE_K;
        Camera_front.Rot_Y := Camera_front.Rot_Y - (X - MPos_front.X) * ROTATE_K;
      end;
    MD_SCALE  :
      Camera_front.Scale := Camera_front.Scale - (Y - MPos_front.Y) * SCALE_K;
    MD_MOVE:
      begin
        Camera_front.pos_y := Camera_front.pos_y + (Y - MPos_front.Y) * MOVE_K / Camera_front.Scale;
        Camera_front.pos_z := Camera_front.pos_z - (X - MPos_front.X) * MOVE_K / Camera_front.Scale;
      end;
  end;

  // NODES SELECT
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_select.Down) then begin
    end_rect := point(X, Y);
    panel_rect := front_view;
  end;

  // NODES MOVE
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    if (not movex_btn.Down) and (not movey_btn.Down) and (not movez_btn.Down) then begin
      dz := (X - MPos_front.X) * MOVE_K / Camera_front.Scale;
      dy := -(Y - MPos_front.Y) * MOVE_K / Camera_front.Scale;
      dx := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - MPos_front.X) * MOVE_K / Camera_front.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - MPos_front.X) * MOVE_K / Camera_front.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - MPos_front.X) * MOVE_K / Camera_front.Scale;
      dy := 0;
      dx := 0;
    end;
    // old_point , grid_point;
    cur_point.x := old_point.x + dx;
    cur_point.y := old_point.y + dy;
    cur_point.z := old_point.z + dz;

    cur_grid.x := to_grid(cur_point.x);
    cur_grid.y := to_grid(cur_point.y);
    cur_grid.z := to_grid(cur_point.z);

    truck.move_selected_node(
      cur_grid.x - grid_point.x,
      cur_grid.y - grid_point.y,
      cur_grid.z - grid_point.z
    );
   old_point := cur_point;
   grid_point := cur_grid;

  end;


  MPos_front := Point(X, Y);
// ограничения всякие
  if Camera_front.Rot_X > 90 then
    Camera_front.Rot_X := 90;
  if Camera_front.Rot_X < -90 then
    Camera_front.Rot_X := -90;
  if Camera_front.Scale < 0.1 then
    Camera_front.Scale := 1;
end;

procedure Teditor_form.front_viewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  MDrag_front := MD_NONE;
  panel_rect := nil;

  if (mode_nodes.Down) and (nodes_select.Down) then
  for i := 0 to truck.num_nodes - 1 do
    if truck.nodes[i].highlight then begin
      truck.nodes[i].highlight := false;
      truck.nodes[i].selected := true;
    end; 
end;

procedure Teditor_form.init;
begin
  init_cams;

  nodes_font_main.inited := false;
  nodes_font_left.inited := false;
  nodes_font_top.inited := false;
  nodes_font_front.inited := false;

  Axis1.Checked := true;
  opened_file := '';
  panel_rect := nil;
  self.DoubleBuffered := true;
  grid_size_tb.Position := 10;
end;

procedure Teditor_form.init_cams;
begin
  Camera_main.Rot_Y := 45;
  Camera_main.Rot_X := -45;
  Camera_main.Scale := 20;
  Camera_main.pos_x := 0;
  Camera_main.pos_y := 0;
  Camera_main.pos_z := 0;

  Camera_left.Rot_Y := 0;
  Camera_left.Rot_X := 0;
  Camera_left.Scale := 10;
  Camera_left.pos_x := 0;
  Camera_left.pos_y := 0;
  Camera_left.pos_z := 0;

  Camera_front.Rot_Y := 90;
  Camera_front.Rot_X := 0;
  Camera_front.Scale := 10;
  Camera_front.pos_x := 0;
  Camera_front.pos_y := 0;
  Camera_front.pos_z := 0;

  Camera_top.Rot_Y := 0;
  Camera_top.Rot_X := 90;
  Camera_top.Scale := 10;
  Camera_top.pos_x := 0;
  Camera_top.pos_y := 0;
  Camera_top.pos_z := 0;
end;

procedure Teditor_form.Left1Click(Sender: TObject);
begin
  Camera_main.Rot_X := 0;
  Camera_main.Rot_Y := 0;
end;

procedure Teditor_form.left_viewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  case Button of
    mbRight  : begin
      MDrag_left := MD_MOVE;
    end;
    //mbRight : MDrag_left := MD_ROTATE;
    mbMiddle : MDrag_left := MD_SCALE;
  end;
  MPos_left := Point(X, Y);

  // NODES SELECT
  if (button=mbleft) and (mode_nodes.Down) and (nodes_select.Down) then begin
    begin_rect := point(X, Y);
    end_rect := point(X, Y);
    if not (ssCtrl in Shift) then truck.deselect_nodes;
    for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].selected and truck.nodes[i].highlight then begin
        truck.nodes[i].selected := false;
        break;
      end;
      if truck.nodes[i].highlight then begin
        truck.set_selected_node(i);
        break;
      end;
    end;
  end;
  // NODES MOVE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    old_point.x := truck.nodes[truck.first_selected_node].x;
    old_point.y := truck.nodes[truck.first_selected_node].y;
    old_point.z := truck.nodes[truck.first_selected_node].z;

    grid_point := old_point;
  end;

  // NODES CREATE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_add.Down) then begin
    truck.add_node(cur_add_node.x, cur_add_node.y, cur_add_node.z, Autoselectnewnodes1.Checked);
  end;

  // BEAMS SELECT
  if (button=mbleft) and (mode_beams.Down) and (beams_select.Down) then begin
    if not (ssCtrl in Shift) then truck.deselect_beams;
    for i := 0 to truck.num_beams - 1 do begin
      if truck.beams[i].selected and truck.beams[i].highlight then begin
        truck.beams[i].selected := false;
        break;
      end;
      if truck.beams[i].highlight then begin
        truck.beams[i].selected := true;
        break;
      end;
    end;
  end;

  // BEAMS ADD
  if (button=mbleft) and (mode_beams.Down) and (beams_add.Down) then begin
    if truck.num_selected_nodes > 2 then begin
      truck.deselect_nodes;
      exit;
    end;
    if truck.num_selected_nodes <=1 then
      for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].highlight then begin
        truck.nodes[i].selected := true;
        break;
        end;
      end;
    if truck.num_selected_nodes = 2 then begin
      truck.connect_sel_nodes(Autoselectnewnodes1.Checked);
      truck.deselect_nodes;
    end;
  end;
end;

procedure Teditor_form.left_viewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx,dy,dz : extended;
  cur_point, cur_grid : tmy_vector;
begin
   case MDrag_left of
    MD_ROTATE :
      begin
        Camera_left.Rot_X := Camera_left.Rot_X - (Y - MPos_left.Y) * ROTATE_K;
        Camera_left.Rot_Y := Camera_left.Rot_Y - (X - MPos_left.X) * ROTATE_K;
      end;
    MD_SCALE  :
      Camera_left.Scale := Camera_left.Scale - (Y - MPos_left.Y) * SCALE_K;
    MD_MOVE:
      begin
        Camera_left.pos_y := Camera_left.pos_y + (Y - MPos_left.Y) * MOVE_K / Camera_left.Scale;
        Camera_left.pos_x := Camera_left.pos_x - (X - MPos_left.X) * MOVE_K / Camera_left.Scale;
      end;
  end;

  // NODES SELECT
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_select.Down) then begin
    end_rect := point(X, Y);
    panel_rect := left_view;
  end;
  
  // NODES MOVE
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    if (not movex_btn.Down) and (not movey_btn.Down) and (not movez_btn.Down) then begin
      dx := (X - MPos_left.X) * MOVE_K / Camera_left.Scale;
      dy := -(Y - MPos_left.Y) * MOVE_K / Camera_left.Scale;
      dz := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - MPos_left.X) * MOVE_K / Camera_left.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - MPos_left.X) * MOVE_K / Camera_left.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - MPos_left.X) * MOVE_K / Camera_left.Scale;
      dy := 0;
      dx := 0;
    end;
    // old_point , grid_point;
    cur_point.x := old_point.x + dx;
    cur_point.y := old_point.y + dy;
    cur_point.z := old_point.z + dz;

    cur_grid.x := to_grid(cur_point.x);
    cur_grid.y := to_grid(cur_point.y);
    cur_grid.z := to_grid(cur_point.z);

    truck.move_selected_node(
      cur_grid.x - grid_point.x,
      cur_grid.y - grid_point.y,
      cur_grid.z - grid_point.z
    );
   old_point := cur_point;
   grid_point := cur_grid;

  end;

  MPos_left := Point(X, Y);
// ограничения всякие
  if Camera_left.Rot_X > 90 then
    Camera_left.Rot_X := 90;
  if Camera_left.Rot_X < -90 then
    Camera_left.Rot_X := -90;
  if Camera_left.Scale < 0.1 then
    Camera_left.Scale := 1;


end;

procedure Teditor_form.left_viewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  MDrag_left := MD_NONE;
  panel_rect := nil;

  if (mode_nodes.Down) and (nodes_select.Down) then
  for i := 0 to truck.num_nodes - 1 do
    if truck.nodes[i].highlight then begin
      truck.nodes[i].highlight := false;
      truck.nodes[i].selected := true;
    end; 
end;


procedure Teditor_form.main_panelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then begin
    main_downed := true;
    set_panels(X, Y);
  end;
end;

procedure Teditor_form.main_panelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if main_downed then begin
    set_panels(X,Y);
  end;
end;

procedure Teditor_form.main_panelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
  main_downed := false;
end;

procedure Teditor_form.redner_all;
begin
  render_view(DC_main,  RC_main,  main_view,  camera_main);
  render_view(DC_left,  RC_left,  left_view,  camera_left);
  render_view(DC_front, RC_front, front_view, camera_front);
  render_view(DC_top,   RC_top,   top_view,   camera_top);

end;

procedure Teditor_form.Open1Click(Sender: TObject);
begin
  if od.Execute then begin
    ClearAll;
    opened_file := od.FileName;
    LoadFile(od.FileName, truck);
    caption := FORM_CAPTION + ' - ' + truck.name;
  end;
end;

procedure Teditor_form.read_params;
var
  F : tinifile;
begin
  F := tinifile.Create(currpath+'options.ini');

  custom_pages.Width := F.ReadInteger('main','edit_panel_width',100);
  if F.ReadBool('main','window_max',false) then
    self.WindowState := wsMaximized
  else
  begin
    self.Width    := F.ReadInteger('main','window_width',500);
    self.Height   := F.ReadInteger('main','window_height',300);
    self.left     := F.ReadInteger('main','window_left',50);
    self.top      := F.ReadInteger('main','window_top',50);
  end;
  set_panels(F.ReadInteger('main','main_view_width',100), F.ReadInteger('main','main_view_height',100));

  // READ ONLY
  points_radius := F.ReadFloat('main','points_radius',3);
{  nodes_font.font_name :=
    F.ReadString('main','nodes_font_name','Arial');
  nodes_font.size :=
    F.ReadInteger('main','nodes_font_size',-12);
  nodes_num_prefix := F.ReadString('main','nodes_num_prefix','nd_');  }

  set_color(F.ReadString('main','back_color',   '000000'), back_color);
  set_color(F.ReadString('main','beam_color',   '884444'), beam_color);
  set_color(F.ReadString('main','node_color',   'FFFFFF'), node_color);
  set_color(F.ReadString('main','shock_color',  '00FF00'), shock_color);
  set_color(F.ReadString('main','command_color','FF0000'), command_color);
  set_color(F.ReadString('main','grid_color',   '222222'), grid_color);

  set_color(F.ReadString('main','node_select_color', '33FFFF'), node_select_color);
  set_color(F.ReadString('main','node_hl_color',     '00FFFF'), node_hl_color);
  set_color(F.ReadString('main','beam_select_color', '33FFFF'), beam_select_color);
  set_color(F.ReadString('main','beam_hl_color',     '00FFFF'), beam_hl_color);
  set_color(F.ReadString('main','nodes_font_color',  '00FF00'), nodes_font_color);

  F.Free;
end;

procedure Teditor_form.render_view(aDC: HDC; aRC: HGLRC; aview: tpanel;
  acamera: tmy_camera);
const
  SYSTEM_BACK_SIZE = 1000;
var
  canvas : TCanvas;
  grid_size : integer;
  grid_step : extended;

  procedure gl_line(x1,y1,z1,x2,y2,z2 : extended);
  begin
    glVertex3f(x1, y1, z1);
    glVertex3f(x2, y2, z2);
  end;

  procedure draw_grid_xy;
  var
    i : integer;
  begin
    glBegin(GL_LINES);
    glColor3f(grid_color[1], grid_color[2], grid_color[3]);
    for i := 0 to grid_size do
    begin
      gl_line(grid_step*i,grid_size*grid_step,0,
              grid_step*i,-grid_size*grid_step,0);
      gl_line(-grid_step*i,grid_size*grid_step,0,
              -grid_step*i,-grid_size*grid_step,0);
      gl_line(grid_size*grid_step,grid_step*i,0,
              -grid_size*grid_step,grid_step*i,0);
      gl_line(grid_size*grid_step,-grid_step*i,0,
              -grid_size*grid_step,-grid_step*i,0);
    end;
    glEnd;
  end;
  procedure draw_grid_yz;
  var
    i : integer;
  begin
    glBegin(GL_LINES);
    glColor3f(grid_color[1], grid_color[2], grid_color[3]);
    for i := 0 to grid_size do
    begin
      gl_line(0, grid_size*grid_step, grid_step*i,
              0,-grid_size*grid_step, grid_step*i);
      gl_line(0, grid_size*grid_step,-grid_step*i,
              0,-grid_size*grid_step,-grid_step*i);
      gl_line(0,grid_step*i,grid_size*grid_step,
              0,grid_step*i,-grid_size*grid_step);
      gl_line(0,-grid_step*i,grid_size*grid_step,
              0,-grid_step*i,-grid_size*grid_step);
    end;
    glEnd;
  end;
  procedure draw_grid_xz;
  var
    i : integer;
  begin
    glBegin(GL_LINES);
    glColor3f(grid_color[1], grid_color[2], grid_color[3]);
    for i := 0 to grid_size do
    begin                                
      gl_line(grid_size*grid_step,0,  grid_step*i,
              -grid_size*grid_step,0, grid_step*i);
      gl_line(grid_size*grid_step,0, -grid_step*i,
              -grid_size*grid_step,0,-grid_step*i);
      gl_line(grid_step*i,0,grid_size*grid_step,
              grid_step*i,0,-grid_size*grid_step);
      gl_line(-grid_step*i,0,grid_size*grid_step,
              -grid_step*i,0,-grid_size*grid_step);
    end;
    glEnd;
  end;
 { procedure draw_back_left;
  begin
    glBegin(GL_QUADS);
    glColor3f(back_color[1],back_color[2],back_color[3]);
    glVertex3f (-SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glVertex3f (-SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glEnd;
  end;
  procedure draw_back_top;
  begin
    glBegin(GL_QUADS);
    glColor3f(back_color[1],back_color[2],back_color[3]);
    glVertex3f (-SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glVertex3f (-SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glEnd;
  end;
  procedure draw_back_front;
  begin
    glBegin(GL_QUADS);
    glColor3f(back_color[1],back_color[2],back_color[3]);
    glVertex3f (SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glVertex3f (SYSTEM_BACK_SIZE, -SYSTEM_BACK_SIZE, SYSTEM_BACK_SIZE);
    glEnd;
  end;    }

begin
  wglMakeCurrent(aDC, aRC);

  glClear(GL_COLOR_BUFFER_BIT);
  glClearColor(back_color[1], back_color[2], back_color[3], 0);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho(-aview.Width / 2, aview.Width / 2,
          -aview.Height / 2, aview.Height / 2, -10000, 10000);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;


  glRotatef(acamera.Rot_X, 1, 0, 0);
  glRotatef(acamera.Rot_Y, 0, 1, 0);
  glScale(acamera.Scale, acamera.Scale, acamera.Scale);
  glTranslatef(-acamera.pos_x,-acamera.pos_y,-acamera.pos_z);

  glViewport(0, 0, aview.Width, aview.Height);

  // update nodes ======================
  if mode_nodes.Down then begin
    // select frame
    if aview = panel_rect then
      update_rect_nodes;
    // highlight nodes
    update_nodes(aview);

    // highlight nodes in add mode
    if nodes_add.Down then
      update_add_nodes(aview);
  end;

  // update beams ==================================
  if mode_beams.Down then begin
    if beams_select.Down then
      update_beams_select(aview);
    // highlight nodes
    if beams_add.Down then update_nodes(aview);

  end;
  // begin render! ===================================
{
  // system back
  if aview = left_view then begin
    draw_back_left;
  end;
  if aview = top_view then begin
    draw_back_top;
  end;
  if aview = front_view then begin
    draw_back_front;
  end;     }


  // GRID
  if Grid1.Checked then begin
    grid_size := 10;
    grid_step := GRID_STEP_K * grid_size_tb.Position;
    if N10x101.Checked then grid_size := 10;
    if N50x501.Checked then grid_size := 59;
    if N100x1001.Checked then grid_size := 100;
    if N500x5001.Checked then grid_size := 500;
    if N1000x10001.Checked then grid_size := 1000;


    if aview = main_view then begin
      if XY_move.Down then draw_grid_xy;
      if ZY_move.Down then draw_grid_yz;
      if XZ_move.Down then draw_grid_xz;
    end;
    if aview = left_view then begin
      draw_grid_xy;
    end;
    if aview = top_view then begin
      draw_grid_xz;
    end;
    if aview = front_view then begin
      draw_grid_yz;
    end;
  end; // grid

  // all objects
  render_mesh;

  // num nodes
  if Shownodes1.Checked and Nodesnum1.Checked then
    render_nodes_num(aDC, aRC, aview, acamera);

  // nodes select frame
  if panel_rect = aview then begin
    render_select_frame
  end;

  // end render ========================================
  SwapBuffers(aDC);
end;

procedure Teditor_form.Resetviewa1Click(Sender: TObject);
begin
  set_panels(100,100);
end;

procedure Teditor_form.Rotate1Click(Sender: TObject);
begin
  Rotate1.Checked := not Rotate1.Checked;
  rotate_timer.Enabled := Rotate1.Checked;
end;

procedure Teditor_form.rotate_timerTimer(Sender: TObject);
begin
  camera_main.Rot_Y := camera_main.Rot_Y + 1;
  Invalidate;
end;

procedure Teditor_form.Save1Click(Sender: TObject);
begin
  if opened_file <> '' then
    SaveFile(opened_file, truck);
end;

procedure Teditor_form.SaveAs1Click(Sender: TObject);
begin
  if sd.Execute then
    SaveFile(sd.FileName, truck);
end;


procedure Teditor_form.set_color(strcolor: string; var gl_color: tmy_glcolor);
var
  r, g, b : byte;
  s : string;
begin
  if length(strcolor) <> 6 then
  begin
    exit;
  end;
  s := UpperCase(strcolor);

  if ord(s[1]) > ord('9') then r := 16*(ord(s[1])-ord('A')+10) else r := 16*(ord(s[1])-ord('0'));
  if ord(s[2]) > ord('9') then r := r +(ord(s[2])-ord('A')+10) else r := r +(ord(s[2])-ord('0'));

  if ord(s[3]) > ord('9') then g := 16*(ord(s[3])-ord('A')+10) else g := 16*(ord(s[3])-ord('0'));
  if ord(s[4]) > ord('9') then g := g +(ord(s[4])-ord('A')+10) else g := g +(ord(s[4])-ord('0'));

  if ord(s[5]) > ord('9') then b := 16*(ord(s[5])-ord('A')+10) else b := 16*(ord(s[5])-ord('0'));
  if ord(s[6]) > ord('9') then b := b +(ord(s[6])-ord('A')+10) else b := b +(ord(s[6])-ord('0'));

  gl_color[1] := r / 255;
  gl_color[2] := g / 255;
  gl_color[3] := b / 255;
end;



procedure Teditor_form.set_panels(x, y: integer);
begin
{    main_view.Top     := 0;
    main_view.Left    := 0;
    main_view.Width   := X-PANELS_OFFSET;
    main_view.Height  := Y-PANELS_OFFSET;

    left_view.Left       := main_view.Width +main_view.Left+ PANELS_OFFSET*2;
    left_view.Top        := main_view.Height + main_view.top+ PANELS_OFFSET*2;
    left_view.Width      := main_panel.Width - main_view.Width -main_view.Left-PANELS_OFFSET*2;
    left_view.Height     :=  main_panel.Height - main_view.Height -main_view.Top- PANELS_OFFSET*2;

    front_view.Left      := main_view.Left;
    front_view.Top       := main_view.Height +main_view.Top+ PANELS_OFFSET*2;
    front_view.Width     := main_view.Width;
    front_view.Height    := main_panel.Height - main_view.Height -main_view.Top- PANELS_OFFSET*2;

    top_view.Left        := main_view.Width +main_view.Left+ PANELS_OFFSET*2;
    top_view.Top         := main_view.Top;
    top_view.Width       := main_panel.Width -main_view.Left-main_view.Width -PANELS_OFFSET*2;
    top_view.Height      := main_view.Height;

    old_panels_x := X;
    old_panels_y := Y;  }
end;

procedure Teditor_form.Showbeams1Click(Sender: TObject);
begin
  Showbeams1.Checked := not Showbeams1.Checked;
end;

procedure Teditor_form.Shownodes1Click(Sender: TObject);
begin
  Shownodes1.Checked := not Shownodes1.Checked;
end;

procedure Teditor_form.Snaptogrid1Click(Sender: TObject);
begin
  Snaptogrid1.Checked := not Snaptogrid1.Checked;
end;

procedure Teditor_form.del_beamsClick(Sender: TObject);
var
  i : integer;
begin
  i := 0;
  while i < truck.num_beams do begin
    if truck.beams[i].selected then begin
      truck.delete_beam(i);
      i := 0;
      continue;
    end;
    inc(i);
  end;
end;

procedure Teditor_form.del_nodesClick(Sender: TObject);
var
  i : integer;
begin
  i := 0;
  while i < truck.num_nodes  do begin
    if truck.nodes[i].selected then begin
      truck.delete_node(i);
      i := 0;
      continue;
    end;
    inc(i);
  end;
end;

procedure Teditor_form.SpeedButton5Click(Sender: TObject);
begin
  truck.clone_selected;
end;

procedure Teditor_form.SpeedButton7Click(Sender: TObject);
begin
  truck.connect_sel_nodes(Autoselectnewnodes1.Checked);
end;

procedure Teditor_form.top_viewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  case Button of
    mbRight  : begin
      MDrag_top := MD_MOVE;
    end;
    //mbRight : MDrag_top := MD_ROTATE;
    mbMiddle : MDrag_top := MD_SCALE;
  end;
  MPos_top := Point(X, Y);

  // NODES SELECT
  if (button=mbleft) and (mode_nodes.Down) and (nodes_select.Down) then begin
    begin_rect := point(X, Y);
    end_rect := point(X, Y);
    if not (ssCtrl in Shift) then truck.deselect_nodes;
    for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].selected and truck.nodes[i].highlight then begin
        truck.nodes[i].selected := false;
        break;
      end;
      if truck.nodes[i].highlight then begin
        truck.set_selected_node(i);
        break;
      end;

    end;
  end;
  // NODES MOVE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    old_point.x := truck.nodes[truck.first_selected_node].x;
    old_point.y := truck.nodes[truck.first_selected_node].y;
    old_point.z := truck.nodes[truck.first_selected_node].z;

    grid_point := old_point;
  end;

  // NODES CREATE
  if (button=mbleft) and (mode_nodes.Down) and (nodes_add.Down) then begin
    truck.add_node(cur_add_node.x, cur_add_node.y, cur_add_node.z, Autoselectnewnodes1.Checked);
  end;

  // BEAMS SELECT
  if (button=mbleft) and (mode_beams.Down) and (beams_select.Down) then begin
    if not (ssCtrl in Shift) then truck.deselect_beams;
    for i := 0 to truck.num_beams - 1 do begin
      if truck.beams[i].selected and truck.beams[i].highlight then begin
        truck.beams[i].selected := false;
        break;
      end;
      if truck.beams[i].highlight then begin
        truck.beams[i].selected := true;
        break;
      end;
    end;
  end;
  // BEAMS ADD
  if (button=mbleft) and (mode_beams.Down) and (beams_add.Down) then begin
    if truck.num_selected_nodes > 2 then begin
      truck.deselect_nodes;
      exit;
    end;
    if truck.num_selected_nodes <=1 then
      for i := 0 to truck.num_nodes - 1 do begin
      if truck.nodes[i].highlight then begin
        truck.nodes[i].selected := true;
        break;
        end;
      end;
    if truck.num_selected_nodes = 2 then begin
      truck.connect_sel_nodes(Autoselectnewnodes1.Checked);
      truck.deselect_nodes;
    end;

  end;
end;

procedure Teditor_form.top_viewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  dx,dy,dz : extended;
  cur_point, cur_grid : tmy_vector;
begin
   case MDrag_top of
    MD_ROTATE :
      begin
        Camera_top.Rot_X := Camera_top.Rot_X - (Y - MPos_top.Y) * ROTATE_K;
        Camera_top.Rot_Y := Camera_top.Rot_Y - (X - MPos_top.X) * ROTATE_K;
      end;
    MD_SCALE  :
      Camera_top.Scale := Camera_top.Scale - (Y - MPos_top.Y) * SCALE_K;
    MD_MOVE:
      begin
        Camera_top.pos_z := Camera_top.pos_z - (Y - MPos_top.Y) * MOVE_K / Camera_top.Scale;
        Camera_top.pos_x := Camera_top.pos_x - (X - MPos_top.X) * MOVE_K / Camera_top.Scale;
      end;
  end;

  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_select.Down) then begin
    end_rect := point(X, Y);
    panel_rect := top_view;
  end;

  // NODES MOVE
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then begin
    if (not movex_btn.Down) and (not movey_btn.Down) and (not movez_btn.Down) then begin
      dx := (X - MPos_top.X) * MOVE_K / Camera_top.Scale;
      dz := (Y - MPos_top.Y) * MOVE_K / Camera_top.Scale;
      dy := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - MPos_top.X) * MOVE_K / Camera_top.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - MPos_top.X) * MOVE_K / Camera_top.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - MPos_top.X) * MOVE_K / Camera_top.Scale;
      dy := 0;
      dx := 0;
    end;
    // old_point , grid_point;
    cur_point.x := old_point.x + dx;
    cur_point.y := old_point.y + dy;
    cur_point.z := old_point.z + dz;

    cur_grid.x := to_grid(cur_point.x);
    cur_grid.y := to_grid(cur_point.y);
    cur_grid.z := to_grid(cur_point.z);

    truck.move_selected_node(
      cur_grid.x - grid_point.x,
      cur_grid.y - grid_point.y,
      cur_grid.z - grid_point.z
    );
   old_point := cur_point;
   grid_point := cur_grid;
  end;


  MPos_top := Point(X, Y);
// ограничения всякие
  if Camera_top.Rot_X > 90 then
    Camera_top.Rot_X := 90;
  if Camera_top.Rot_X < -90 then
    Camera_top.Rot_X := -90;
  if Camera_top.Scale < 0.1 then
    Camera_top.Scale := 1;

end;

procedure Teditor_form.top_viewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  MDrag_top := MD_NONE;
  panel_rect := nil;

  if (mode_nodes.Down) and (nodes_select.Down) then
  for i := 0 to truck.num_nodes - 1 do
    if truck.nodes[i].highlight then begin
      truck.nodes[i].highlight := false;
      truck.nodes[i].selected := true;
    end; 
end;

function Teditor_form.to_grid(value: extended): extended;
var
  grid_step : extended;
begin
  grid_step := GRID_STEP_K * grid_size_tb.Position;
  if Snaptogrid1.Checked then
    result := round(value / grid_step) * grid_step
  else
    result := value;
end;

procedure Teditor_form.update_add_nodes(aview: tpanel);
var
  mpos, cpos : tpoint;
  Viewport : Array [0..3] of GLInt;
  mvMatrix, ProjMatrix : Array [0..15] of GLDouble;
  wx, wy, wz : GLdouble;
  Zval : GLfloat;
begin
  if aview = main_view then begin
    exit;
  end;
  
  mpos := mousepos;
  cpos := aview.ScreenToClient(mpos);
  cpos.Y := aview.Height - cpos.Y;
  if      (cpos.X > 0)
      and (cpos.Y > 0)
      and (cpos.X <= aview.Width)
      and (cpos.Y <= aview.Height)
  then
  begin
  cur_add_node.x := 0;
  cur_add_node.y := 0;
  cur_add_node.z := 0;

  glGetIntegerv (GL_VIEWPORT, @Viewport);
  glGetDoublev (GL_MODELVIEW_MATRIX, @mvMatrix);
  glGetDoublev (GL_PROJECTION_MATRIX, @ProjMatrix);

  glReadPixels(cpos.X, cpos.Y, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, @Zval);

  gluUnProject (cpos.X, cpos.Y, Zval,
                  @mvMatrix, @ProjMatrix, @Viewport, wx, wy, wz);

{  caption :=   FloatToStr(Zval)
              + ' : ' + chr (13) + '(' + FloatToStr(wx)
              + '; ' + FloatToStr(wy)
              + '; ' + FloatToStr(wz) + ')';    }
  if Snaptogrid1.Checked then begin
    wx := to_grid(wx);
    wy := to_grid(wy);
    wz := to_grid(wz);
  end;


  if aview = top_view then begin
    cur_add_node.x := wx;
    cur_add_node.z := wz;
  end;
  if aview = left_view then begin
    cur_add_node.x := wx;
    cur_add_node.y := wy;
  end;
  if aview = front_view then begin
    cur_add_node.z := wz;
    cur_add_node.y := wy;
  end;

  end;
end;

procedure Teditor_form.update_beams_select(aview: tpanel);
var
  mpos, cpos : tpoint;
  Viewport : Array [0..3] of GLInt;
  mvMatrix, ProjMatrix : Array [0..15] of GLDouble;
  wx, wy, wz : GLdouble;
  i, nid_begin, nid_end : integer;

  px1, py1, px2, py2, dx, dy, dx1, dy1, x1, y1,
  cx,cy,cz, ext : extended;
begin
  mpos := mousepos;
  cpos := aview.ScreenToClient(mpos);
  cpos.Y := aview.Height - cpos.Y +1;
  if      (cpos.X > 0)
      and (cpos.Y > 0)
      and (cpos.X <= aview.Width)
      and (cpos.Y <= aview.Height)
  then begin
    for i := 0 to truck.num_beams - 1 do
      truck.beams[i].highlight := false;

    glGetIntegerv (GL_VIEWPORT, @Viewport);
    glGetDoublev (GL_MODELVIEW_MATRIX, @mvMatrix);
    glGetDoublev (GL_PROJECTION_MATRIX, @ProjMatrix);
    for i := 0 to truck.num_beams - 1 do begin
      nid_begin := truck.find_nodeid(truck.beams[i].id_begin);
      nid_end := truck.find_nodeid(truck.beams[i].id_end);
      if (nid_begin < 0) or (nid_end < 0) then continue;


      cx := truck.nodes[nid_begin].x;
      cy := truck.nodes[nid_begin].y;
      cz := truck.nodes[nid_begin].z;
      gluProject (
                  cx,
                  cy,
                  cz,
                  @mvMatrix, @ProjMatrix, @Viewport,
                  wx, wy, wz
                  );
      px1 := wx; py1 := wy;
      gluProject (
                  truck.nodes[nid_end].x,
                  truck.nodes[nid_end].y,
                  truck.nodes[nid_end].z,
                  @mvMatrix, @ProjMatrix, @Viewport,
                  wx, wy, wz
                  );
      px2 := wx; py2 := wy;
      if abs(px2-px1) > abs(py2-py1) then begin
      if px1>px2 then begin
                              ext := px1; px1 := px2; px2 := ext;
                              ext := py1; py1 := py2; py2 := ext;
                      end;
      end else begin
      if py1>py2 then begin
                              ext := px1; px1 := px2; px2 := ext;
                              ext := py1; py1 := py2; py2 := ext;
                      end;
      end;
      dx := px2 - px1;
      dy := py2 - py1;
      dx1 := cpos.X - px1;
      dy1 := cpos.Y - py1;
      x1 := px1 + ((dy1 * dx) / dy);
      y1 := py1 + ((dx1 * dy) / dx);

{      if aview=main_view then
      caption :='x: '+inttostr(cpos.X)+' y:'+inttostr(cpos.Y) +
        'py1: '+inttostr(round(py1))+' px1:'+inttostr(round(px1))+
        ' y1:'+inttostr(round(y1));       }
      if abs(px2-px1) > abs(py2-py1) then begin
        if      (cpos.x >= px1-BEAM_SELECT_RANGE) and (cpos.X <= px2+BEAM_SELECT_RANGE)
          and (cpos.y >= y1-BEAM_SELECT_RANGE)  and (cpos.Y <= y1+BEAM_SELECT_RANGE)
        then begin
          truck.beams[i].highlight := true;
          exit;
        end;
      end else begin
        if      (cpos.y >= py1-BEAM_SELECT_RANGE) and (cpos.y <= py2+BEAM_SELECT_RANGE)
          and (cpos.x >= x1-BEAM_SELECT_RANGE)  and (cpos.x <= x1+BEAM_SELECT_RANGE)
        then begin
          truck.beams[i].highlight := true;
          exit;
        end;
      end;
    end;
  end;
end;

procedure Teditor_form.update_nodes(aview :tpanel);
var
  mpos, cpos : tpoint;
  i : integer;

  Viewport : Array [0..3] of GLInt;
  mvMatrix, ProjMatrix : Array [0..15] of GLDouble;
  wx, wy, wz : GLdouble;
begin
  if panel_rect <> nil then exit;
  // ONLY IF SELECT NODES
  if ((mode_nodes.Down) and (nodes_select.Down))
    or  ( (mode_beams.Down) and (beams_add.Down) )
  then begin

  mpos := mousepos;
  cpos := aview.ScreenToClient(mpos);
  cpos.Y := aview.Height - cpos.Y;
  if      (cpos.X > 0)
      and (cpos.Y > 0)
      and (cpos.X <= aview.Width)
      and (cpos.Y <= aview.Height)
  then
  begin
    for i := 0 to truck.num_nodes - 1 do
      truck.nodes[i].highlight := false;

    for i := 0 to truck.num_nodes - 1 do begin

      glGetIntegerv (GL_VIEWPORT, @Viewport);
      glGetDoublev (GL_MODELVIEW_MATRIX, @mvMatrix);
      glGetDoublev (GL_PROJECTION_MATRIX, @ProjMatrix);
      gluProject (truck.nodes[i].x, truck.nodes[i].y, truck.nodes[i].z,
        @mvMatrix, @ProjMatrix, @Viewport, wx, wy, wz);

      if  (wx > cpos.X - NODE_SELECT_RANGE)
      and (wx < cpos.X + NODE_SELECT_RANGE)
      and (wy > cpos.Y - NODE_SELECT_RANGE)
      and (wy < cpos.Y + NODE_SELECT_RANGE) then begin
        truck.nodes[i].highlight := true;
        exit;
      end;
    end;
  end;
  end;
end;

procedure Teditor_form.update_rect_nodes;
var
  i : integer;
  cpos : tpoint;
  cwidth , cheight : integer;
  Viewport : Array [0..3] of GLInt;
  mvMatrix, ProjMatrix : Array [0..15] of GLDouble;
  wx, wy, wz : GLdouble;
  b_point, e_point : tpoint;
begin
  if panel_rect = nil then exit;
  b_point.X := begin_rect.X;
  e_point.X := end_rect.X;
  b_point.Y  := panel_rect.Height - begin_rect.Y;
  e_point.Y    := panel_rect.Height - end_rect.Y;
  if      (b_point.X > 0)
      and (b_point.Y > 0)
      and (b_point.X <= panel_rect.Width)
      and (b_point.Y <= panel_rect.Height)
      
      and (e_point.X > 0)
      and (e_point.Y > 0)
      and (e_point.X <= panel_rect.Width)
      and (e_point.Y <= panel_rect.Height)
  then
  begin
    if b_point.X>e_point.X then cpos.X := e_point.X else cpos.X := b_point.X;
    if b_point.Y>e_point.Y then cpos.Y := e_point.Y else cpos.Y := b_point.Y;
    cwidth := b_point.X - e_point.X;
    if cwidth < 0 then cwidth := -cwidth;
    cheight := b_point.Y - e_point.Y;
    if cheight < 0 then cheight := -cheight;

    glGetIntegerv (GL_VIEWPORT, @Viewport);
    glGetDoublev (GL_MODELVIEW_MATRIX, @mvMatrix);
    glGetDoublev (GL_PROJECTION_MATRIX, @ProjMatrix);
    for i := 0 to truck.num_nodes - 1 do
      truck.nodes[i].highlight := false;

    for i := 0 to truck.num_nodes - 1 do begin

      gluProject (truck.nodes[i].x, truck.nodes[i].y, truck.nodes[i].z,
        @mvMatrix, @ProjMatrix, @Viewport, wx, wy, wz);

      if  (wx > cpos.X)
      and (wx < cpos.X + cwidth)
      and (wy > cpos.Y)
      and (wy < cpos.Y + cheight) then begin
        truck.nodes[i].highlight := true;
      end;
    end;
  end;
end;

procedure Teditor_form.write_params;
var
  F : tinifile;
begin
  F := tinifile.Create(currpath+'options.ini');
  F.WriteInteger('main','edit_panel_width',custom_pages.Width);
  if self.WindowState = wsMaximized then
    F.WriteBool('main','window_max',true)
  else
  begin
    F.WriteBool('main','window_max',false);
    F.WriteInteger('main','window_width',self.Width );
    F.WriteInteger('main','window_height',self.height );
    F.WriteInteger('main','window_left',self.Left );
    F.WriteInteger('main','window_top',self.Top );
  end;

  F.WriteInteger('main','main_view_width',main_view.Width + PANELS_OFFSET);
  F.WriteInteger('main','main_view_height',main_view.Height + PANELS_OFFSET);
  F.Free;
end;

{ Tmy_viewport }

procedure Tmy_viewport.finit_gl;
begin
  wglDeleteContext(RC);
  ReleaseDC(panel.Handle,DC);
  DeleteDC(DC);
end;

procedure Tmy_viewport.init_cam;
begin
  case view_type of
    vt_free: begin
      camera.Rot_Y := 45;
      camera.Rot_X := -45;
      camera.Scale := 20;
      camera.pos_x := 0;
      camera.pos_y := 0;
      camera.pos_z := 0;
    end;
    vt_left: begin
      camera.Rot_Y := 0;
      camera.Rot_X := 0;
      camera.Scale := 10;
      camera.pos_x := 0;
      camera.pos_y := 0;
      camera.pos_z := 0;
    end;
    vt_front: begin
      camera.Rot_Y := 90;
      camera.Rot_X := 0;
      camera.Scale := 10;
      camera.pos_x := 0;
      camera.pos_y := 0;
      camera.pos_z := 0;
    end;
    vt_top: begin
      camera.Rot_Y := 0;
      camera.Rot_X := 90;
      camera.Scale := 10;
      camera.pos_x := 0;
      camera.pos_y := 0;
      camera.pos_z := 0;
    end;
  end;
end;

procedure Tmy_viewport.init_gl;
var
  pfd : TPixelFormatDescriptor;
begin
  DC := GetDC(panel.Handle);

  FillChar(pfd, SizeOf(pfd), 0);
  with pfd do
  begin
    nSize        := SizeOf(pfd);
    nVersion     := 1;
    dwFlags      := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
    cColorBits   := 32;
    cDepthBits   := 24;
    cStencilBits := 8;
  end;

  SetPixelFormat(DC,  ChoosePixelFormat(DC, @pfd), @pfd);
  RC   := wglCreateContext(DC);
end;

end.
