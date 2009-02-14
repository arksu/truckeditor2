unit main;

interface
{
  +номера нод
  +масштаб колесиком мыши

  колеса
  шоки
  командные грани
  отмена и повтор действий
  перемещение нод по осям без разделения режимов "выбор" и "перемещение"
}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, OpenGL, AppEvnts, Menus, IniFiles, Buttons, ComCtrls,
  StdCtrls, mmSystem,

  view_unit, properties_unit,
  
  utils, gl_font, truck_file;

type
  tmy_vector = record x, y, z : extended; end;
  
  tmy_glcolor = array [1..3] of extended;


  Teditor_form = class(TForm)
{$region 'system'}


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
    mode_view: TSpeedButton;
    mode_nodes: TSpeedButton;
    mode_beams: TSpeedButton;
    nodes_select: TSpeedButton;
    nodes_move: TSpeedButton;
    xy_btn: TSpeedButton;
    z_btn: TSpeedButton;
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
    nodes_add: TSpeedButton;
    Autoselectnewnodes1: TMenuItem;
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
    Deleteallviews1: TMenuItem;
    Shownumselnodes1: TMenuItem;
    Showcameras1: TMenuItem;
    Fileinfoedit1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Showinvisiblenodes1: TMenuItem;
    Options1: TMenuItem;
    Showshocks1: TMenuItem;
    Showhydros1: TMenuItem;
    ShowCommands1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Clear1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure N10x101Click(Sender: TObject);
    procedure N50x501Click(Sender: TObject);
    procedure N100x1001Click(Sender: TObject);
    procedure N500x5001Click(Sender: TObject);
    procedure N1000x10001Click(Sender: TObject);
    procedure grid_size_tbChange(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure Autoselectnewnodes1Click(Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure del_nodesClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure beams_addClick(Sender: TObject);
    procedure mode_beamsClick(Sender: TObject);
    procedure del_beamsClick(Sender: TObject);
    procedure Free1Click(Sender: TObject);
    procedure Left2Click(Sender: TObject);
    procedure op2Click(Sender: TObject);
    procedure Front2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Deleteallviews1Click(Sender: TObject);
    procedure Fileinfoedit1Click(Sender: TObject);
    procedure ShowCommands1Click(Sender: TObject);
{$endregion}
  private
    mmResult: Integer;

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
    hydro_color       : tmy_glcolor;
    command_color     : tmy_glcolor;
    grid_color        : tmy_glcolor;
    cameras_color     : tmy_glcolor;
    cameras_font_color : tmy_glcolor;
    {---------------------------------------------}
    node_select_color : tmy_glcolor;
    node_hl_color     : tmy_glcolor;
    beam_select_color : tmy_glcolor;
    beam_hl_color     : tmy_glcolor;
    {---------------------------------------------}
    points_radius     : single; // радиус точки
    begin_rect        : tpoint;
    end_rect          : tpoint;
    panel_rect        : tpanel;
    opened_file       : string;
    {---------------------------------------------}
    old_point,
    grid_point,
    cur_add_node      : tmy_vector;
    {---------------------------------------------}
    nodes_num_prefix  : string;
    view_font_name   : string;
    view_font_size   : integer;

    render_vp         : tmy_viewport;


    procedure set_color(strcolor : string; var gl_color : tmy_glcolor);
  public
    truck             : tmy_truck;
    views             : array of tmy_viewport;

    procedure add_view(atype : tviewport_type);
    function  get_view(aform : Tview_form) : tmy_viewport; overload;
    function  get_view(apanel : tpanel) : tmy_viewport; overload;
    procedure delete_view(aform : Tview_form);
    procedure write_views;
    procedure read_views;
    procedure views_reset_fonts;

    procedure init;
    procedure read_params; // прочитать параметры из ини файла
    procedure write_params; // записать параметры в ини файл
    procedure ClearAll; // очистить все ресурсы

    procedure redner_all;
    procedure render_mesh;
    procedure render_view(aDC: HDC;
        aRC : HGLRC;
        aview : tpanel;
        acamera : tmy_camera);
    procedure render_select_frame;
    procedure render_nodes_num(aview: tpanel);
    procedure render_cameras;

    procedure update_nodes(aview :tpanel);
    procedure update_add_nodes(aview :tpanel);
    procedure update_rect_nodes;
    procedure update_beams_select(aview :tpanel);

    function  to_grid(value : extended) : extended;
    procedure after_load;
    procedure prepare_save;

    procedure view_MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure view_MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure view_MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;
  
const
  FORM_CAPTION      = 'Truck editor';
  AXIS_LENGTH       = 20;  // длина осей
  COMMENT_CHAR      = ';'; // символ комментария

  // коэффициенты камеры
  ROTATE_K          = 0.3; // вращение
  SCALE_K           = 0.1; // масштаб
  MOVE_K            = 0.9; // перемещение
  MOUSE_WHEEL_K     = 30;

  GRID_STEP_K       = 0.1; // множитель для создания сетки (умножается на значение ползунка)
  HIGHLIGHT_K       = 0.1; // размер осей вокруг подсвеченной ноды

  NODE_SELECT_RANGE = 2;   // размер квадрата вокруг ноды для выбора в виде
  BEAM_SELECT_RANGE = 2;   // диапазон по вертикали для выбора ребра

var
  editor_form: Teditor_form;

procedure TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;

implementation

{$R *.dfm}

procedure TimeCallBack(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); stdcall;
var
  i : integer;
begin
  for i := 0 to length(editor_form.views) - 1 do
    if editor_form.views[i].view_type = vt_free then
    begin
      editor_form.views[i].camera.Rot_Y := editor_form.views[i].camera.Rot_Y + 1;
      editor_form.Invalidate;
//      editor_form.redner_all;
    end;
end;

procedure Teditor_form.add_view(atype: tviewport_type);
begin
  setlength(views, length(views) + 1);
  views[length(views)-1] := Tmy_viewport.Create;
  with views[length(views)-1] do begin
    view_type := atype;
    Application.CreateForm(Tview_form, form);
    form.vp := views[length(views)-1];
    form.Show;
    form.view_panel.OnMouseDown   := view_MouseDown;
    form.view_panel.OnMouseMove   := view_MouseMove;
    form.view_panel.OnMouseUp     := view_MouseUp;
    nodes_font.font_name := view_font_name;
    nodes_font.size := view_font_size;
    init;
    init_gl;
    init_cam;
  end;
end;

procedure Teditor_form.after_load;
begin
  caption                                 := truck.name + ' - ' + FORM_CAPTION;
  properties_form.name_edit.Text          := truck.name;
  properties_form.ffversion_edit.Text     := truck.fileformatversion;
  properties_form.desc_memo.lines.AddStrings(truck.description);
  properties_form.help_edit.Text          := truck.help;
end;

procedure Teditor_form.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  Done := true;
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

procedure Teditor_form.Deleteallviews1Click(Sender: TObject);
var
  i : integer;
begin
  while length(views) > 0 do
    views[0].form.Close;
end;

procedure Teditor_form.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure Teditor_form.render_cameras;
begin
    glColor3f(cameras_color[1], cameras_color[2], cameras_color[3]);
    glLineWidth(5);

    glBegin(GL_LINES);
        with truck.nodes[truck.find_nodeid(truck.camera[1])] do
          glVertex3f(x, y, z);
        with truck.nodes[truck.find_nodeid(truck.camera[2])] do
          glVertex3f(x, y, z);

        with truck.nodes[truck.find_nodeid(truck.camera[1])] do
          glVertex3f(x, y, z);
        with truck.nodes[truck.find_nodeid(truck.camera[3])] do
          glVertex3f(x, y, z);
    glEnd;

    glColor3f(cameras_font_color[1], cameras_font_color[2], cameras_font_color[3]);
    // center
    render_vp.nodes_font.Init;
    with truck.nodes[truck.find_nodeid(truck.camera[1])] do
    render_vp.nodes_font.Print(
                      x,
                      y,
                      z,
                      'Center'
                    );

    // back
    render_vp.nodes_font.Init;
    with truck.nodes[truck.find_nodeid(truck.camera[2])] do
    render_vp.nodes_font.Print(
                      x,
                      y,
                      z,
                      'Back'
                    );

    // left
    render_vp.nodes_font.Init;
    with truck.nodes[truck.find_nodeid(truck.camera[3])] do
    render_vp.nodes_font.Print(
                      x,
                      y,
                      z,
                      'Left'
                    );
end;

procedure Teditor_form.render_mesh;
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
    for i := 0 to truck.num_beams - 1 do
      with truck.beams[i] do
      begin
        // HL
        if highlight then begin
          glColor3f(beam_hl_color[1], beam_hl_color[2],beam_hl_color[3]);
          glLineWidth(3);
        // SELECT
        end else if selected then begin
          glColor3f(beam_select_color[1],beam_select_color[2],beam_select_color[3]);
          glLineWidth(3);
        // NORMAL
        end else begin
          glColor3f(beam_color[1], beam_color[2], beam_color[3]);
          glLineWidth(1);
        end;

        // invisible ==============================
        if (truck.beam_invisible(i)) then begin
          if Showinvisiblenodes1.Checked then begin
              glBegin(GL_LINES);
              with truck.nodes[truck.find_nodeid(id_begin)] do
                glVertex3f(x, y, z);
              with truck.nodes[truck.find_nodeid(id_end)] do
                glVertex3f(x, y, z);
              glEnd;
          end;
        end else begin //================================
            glBegin(GL_LINES);
            with truck.nodes[truck.find_nodeid(id_begin)] do
              glVertex3f(x, y, z);
            with truck.nodes[truck.find_nodeid(id_end)] do
              glVertex3f(x, y, z);
            glEnd;
        end; //=======================================
      end;

    // HYDROS ==================================================================
    if Showhydros1.Checked then
    for i := 0 to truck.num_hydros - 1 do
      with truck.hydros[i] do
      begin
        // HL
        if highlight then begin
          glColor3f(beam_hl_color[1], beam_hl_color[2],beam_hl_color[3]);
          glLineWidth(3);
        // SELECT
        end else if selected then begin
          glColor3f(beam_select_color[1],beam_select_color[2],beam_select_color[3]);
          glLineWidth(3);
        // NORMAL
        end else begin
          glColor3f(hydro_color[1], hydro_color[2], hydro_color[3]);
          glLineWidth(2);
        end;

        glBegin(GL_LINES);
        with truck.nodes[truck.find_nodeid(id_begin)] do
          glVertex3f(x, y, z);
        with truck.nodes[truck.find_nodeid(id_end)] do
          glVertex3f(x, y, z);
        glEnd;
      end; // end with

    // SHOCKS ==================================================================
    if Showshocks1.Checked then
    for i := 0 to truck.num_shocks - 1 do
      with truck.shocks[i] do
      begin
        // HL
        if highlight then begin
          glColor3f(beam_hl_color[1], beam_hl_color[2],beam_hl_color[3]);
          glLineWidth(3);
        // SELECT
        end else if selected then begin
          glColor3f(beam_select_color[1],beam_select_color[2],beam_select_color[3]);
          glLineWidth(3);
        // NORMAL
        end else begin
          glColor3f(shock_color[1], shock_color[2], shock_color[3]);
          glLineWidth(2);
        end;

        glBegin(GL_LINES);
        with truck.nodes[truck.find_nodeid(id_begin)] do
          glVertex3f(x, y, z);
        with truck.nodes[truck.find_nodeid(id_end)] do
          glVertex3f(x, y, z);
        glEnd;
      end; // end with
      
    // COMMANDS ==================================================================
    if ShowCommands1.Checked then
    for i := 0 to truck.num_commands - 1 do
      with truck.commands[i] do
      begin
        // HL
        if highlight then begin
          glColor3f(beam_hl_color[1], beam_hl_color[2],beam_hl_color[3]);
          glLineWidth(3);
        // SELECT
        end else if selected then begin
          glColor3f(beam_select_color[1],beam_select_color[2],beam_select_color[3]);
          glLineWidth(3);
        // NORMAL
        end else begin
          glColor3f(command_color[1], command_color[2], command_color[3]);
          glLineWidth(2);
        end;

        glBegin(GL_LINES);
        with truck.nodes[truck.find_nodeid(id_begin)] do
          glVertex3f(x, y, z);
        with truck.nodes[truck.find_nodeid(id_end)] do
          glVertex3f(x, y, z);
        glEnd;
      end; // end with
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
// CAMERAS
  if (Showcameras1.Checked)
  and (truck.cameras_exist) then begin
    render_cameras;
  end;
{==============================================================================}
// HIGHLIGHT NEW NODE
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
            glColor3f(node_hl_color[1], node_hl_color[2], node_hl_color[3]);
            glPointSize(6);
            glVertex3f(x, y, z);
          glEnd;
  end;
{==============================================================================}
// HIGHLIGHT NEW BEAM
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

procedure Teditor_form.render_nodes_num(aview: tpanel);
var
  i : integer;
begin
  glColor3f(nodes_font_color[1],nodes_font_color[2],nodes_font_color[3]);
  for i := 0 to truck.num_nodes - 1 do 
    if (Shownumselnodes1.Checked and (truck.nodes[i].selected))
    or (Nodesnum1.Checked) then begin

    render_vp.nodes_font.Init;
    render_vp.nodes_font.Print(
                      truck.nodes[i].x,
                      truck.nodes[i].y,
                      truck.nodes[i].z,
                      nodes_num_prefix+inttostr(truck.nodes[i].id)
                    );
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
  glLineWidth(1);
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

procedure Teditor_form.op2Click(Sender: TObject);
begin
  add_view(vt_top);
end;

procedure Teditor_form.Fileinfoedit1Click(Sender: TObject);
begin
  properties_form.Show;
end;

procedure Teditor_form.FormCreate(Sender: TObject);
var
  pfd : TPixelFormatDescriptor;
begin
  truck := tmy_truck.Create;
  read_params;
  caption := FORM_CAPTION;
  

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
var
  i :integer;
begin
  write_views;
  write_params;
  ClearAll;

  wglMakeCurrent(0,0);

  i := 0;
  while i < length(views) do begin
    views[i].Free;
    inc(i);
  end;
  setlength(views, 0);
  truck.Free;
end;

procedure Teditor_form.FormShow(Sender: TObject);
begin
  read_views;

end;

procedure Teditor_form.Grid1Click(Sender: TObject);
begin
  Grid1.Checked := not Grid1.Checked;
end;

procedure Teditor_form.grid_size_tbChange(Sender: TObject);
begin
  label1.Caption := 'Cell size: '+floattostr(GRID_STEP_K * grid_size_tb.Position);
end;

procedure Teditor_form.Free1Click(Sender: TObject);
begin
  add_view(vt_Free);
end;

procedure Teditor_form.Front2Click(Sender: TObject);
begin
  add_view(vt_front);
end;

function Teditor_form.get_view(apanel: tpanel): tmy_viewport;
var
  i : integer;
begin
  result := nil;
  for i := 0 to length(views) - 1 do
    if views[i].form.view_panel = apanel then
      begin
        result := views[i];
        exit;
      end;
end;

function Teditor_form.get_view(aform : Tview_form): tmy_viewport;
var
  i : integer;
begin
  result := nil;
  for i := 0 to length(views) - 1 do
    if views[i].form = aform then
      begin
        result := views[i];
        exit;
      end;
end;

procedure Teditor_form.init;
begin
  Axis1.Checked := true;
  opened_file := '';
  panel_rect := nil;
  self.DoubleBuffered := true;
  grid_size_tb.Position := 10;
end;


procedure Teditor_form.Left2Click(Sender: TObject);
begin
  add_view(vt_left);
end;

procedure Teditor_form.redner_all;
var
  i : integer;
begin
  for i := 0 to length(views) - 1 do
    render_view(
      views[i].DC,
      views[i].RC,
      views[i].form.view_panel,
      views[i].Camera
    );
end;

procedure Teditor_form.Open1Click(Sender: TObject);
begin
  if od.Execute then begin
    ClearAll;
    opened_file := od.FileName;
    LoadFile(od.FileName, truck);
    after_load;
  end;
end;

procedure Teditor_form.prepare_save;
begin
  truck.name                  := properties_form.name_edit.Text;
  truck.fileformatversion     := properties_form.ffversion_edit.Text;
  truck.description.Clear;
  truck.description.AddStrings(properties_form.desc_memo.Lines);
  truck.help                  := properties_form.help_edit.Text;
end;

procedure Teditor_form.read_params;
var
  F : tinifile;
begin
  F := tinifile.Create(currpath+'options.ini');

  if F.ReadBool('main','window_max',false) then
    self.WindowState := wsMaximized
  else
  begin
    self.Width    := F.ReadInteger('main','window_width',500);
    self.Height   := F.ReadInteger('main','window_height',300);
    self.left     := F.ReadInteger('main','window_left',50);
    self.top      := F.ReadInteger('main','window_top',50);
  end;

  // READ ONLY
  points_radius := F.ReadFloat('main','points_radius',3);
  view_font_name :=
    F.ReadString('main','view_font_name','Arial');
  view_font_size :=
    F.ReadInteger('main','view_font_size',-12);
  nodes_num_prefix := F.ReadString('main','nodes_num_prefix','nd_');  

  set_color(F.ReadString('main','back_color',   '000000'), back_color);
  set_color(F.ReadString('main','beam_color',   '884444'), beam_color);
  set_color(F.ReadString('main','node_color',   'FFFFFF'), node_color);
  set_color(F.ReadString('main','shock_color',  '00FF00'), shock_color);
  set_color(F.ReadString('main','hydro_color',  'ed18d6'), hydro_color);
  set_color(F.ReadString('main','command_color','FF0000'), command_color);
  set_color(F.ReadString('main','grid_color',   '222222'), grid_color);

  set_color(F.ReadString('main','node_select_color', '33FFFF'), node_select_color);
  set_color(F.ReadString('main','node_hl_color',     '00FFFF'), node_hl_color);
  set_color(F.ReadString('main','beam_select_color', '33FFFF'), beam_select_color);
  set_color(F.ReadString('main','beam_hl_color',     '00FFFF'), beam_hl_color);
  set_color(F.ReadString('main','nodes_font_color',  '00FF00'), nodes_font_color);
  set_color(F.ReadString('main','cameras_color',     '00FFFF'), cameras_color);
  set_color(F.ReadString('main','cameras_font_color','00FF00'), cameras_font_color);

  F.Free;
end;

procedure Teditor_form.read_views;
var
  F : tinifile;
  i, num, t : integer;
begin
  F := tinifile.Create(currpath+'options.ini');
  num := F.ReadInteger('views','num', 0);
  for i := 0 to num - 1 do begin
    t := F.ReadInteger('views','view_'+inttostr(i)+'_type',0);
    case t of
      0: add_view(vt_free);
      1: add_view(vt_left);
      2: add_view(vt_front);
      3: add_view(vt_top);
    end;
    with views[length(views)-1] do begin
      form.Left := F.ReadInteger('views','view_'+inttostr(i)+'_form_left',100);
      form.top := F.ReadInteger('views','view_'+inttostr(i)+'_form_top',100);
      form.width := F.ReadInteger('views','view_'+inttostr(i)+'_form_width',100);
      form.height := F.ReadInteger('views','view_'+inttostr(i)+'_form_height',100);
    end;
  end;

  F.Free;
end;

procedure Teditor_form.render_view(aDC: HDC; aRC: HGLRC; aview: tpanel;
  acamera: tmy_camera);
const
  SYSTEM_BACK_SIZE = 1000;
var
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

begin
  render_vp := get_view(aview);
  if render_vp = nil then exit;

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

  // GRID
  if Grid1.Checked then begin
    grid_size := 10;
    grid_step := GRID_STEP_K * grid_size_tb.Position;
    if N10x101.Checked then grid_size := 10;
    if N50x501.Checked then grid_size := 59;
    if N100x1001.Checked then grid_size := 100;
    if N500x5001.Checked then grid_size := 500;
    if N1000x10001.Checked then grid_size := 1000;

    case render_vp.view_type of
      vt_free: begin
        if XY_move.Down then draw_grid_xy;
        if ZY_move.Down then draw_grid_yz;
        if XZ_move.Down then draw_grid_xz;
      end;
      vt_left:
        draw_grid_xy;
      vt_front:
        draw_grid_yz;
      vt_top:
        draw_grid_xz;
    end;
  end; // grid

  // all objects
  render_mesh;

  // num nodes
  if Shownodes1.Checked and (Nodesnum1.Checked or Shownumselnodes1.Checked) then
    render_nodes_num(aview);

  // nodes select frame
  if panel_rect = aview then begin
    render_select_frame;
  end;

  // end render ========================================
  SwapBuffers(aDC);
end;

procedure Teditor_form.Rotate1Click(Sender: TObject);
begin
  Rotate1.Checked := not Rotate1.Checked;

  if Rotate1.Checked then
    mmResult := TimeSetEvent(40, 0, @TimeCallBack, 0, TIME_PERIODIC)
  else
    TimeKillEvent(mmResult);

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

procedure Teditor_form.delete_view(aform : Tview_form);
var
  i : integer;
begin
  i := 0;
  while i < length(views) do begin
    if views[i].form = aform then begin
        views[i].finit_gl;
        views[i].Free;
        while i < length(views)-1 do begin
          views[i] := views[i+1];
          inc(i);
        end;
        setlength(views, length(views) -1);
        views_reset_fonts;
        exit;

    end;
    inc(i);
  end;
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
  vp : tmy_viewport;
begin
  vp := get_view(aview); if vp = nil then exit;
                         
  if vp.view_type = vt_free then exit;
  
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

  if Snaptogrid1.Checked then begin
    wx := to_grid(wx);
    wy := to_grid(wy);
    wz := to_grid(wz);
  end;


  if vp.view_type = vt_top then begin
    cur_add_node.x := wx;
    cur_add_node.z := wz;
  end;
  if vp.view_type = vt_left then begin
    cur_add_node.x := wx;
    cur_add_node.y := wy;
  end;
  if vp.view_type = vt_front then begin
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

procedure Teditor_form.views_reset_fonts;
var
  i : integer;
begin
  for i := 0 to length(views) - 1 do begin
    views[i].nodes_font.Free;
    views[i].nodes_font := tgl_font.Create;
    views[i].nodes_font.font_name := view_font_name;
    views[i].nodes_font.size := view_font_size;
  end;
end;

procedure Teditor_form.ShowCommands1Click(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
end;

procedure Teditor_form.view_MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
  vp : tmy_viewport;
begin
  vp := get_view(sender as tpanel);
  if vp = nil then exit;

  case Button of
    mbLeft  : begin
      if vp.view_type = vt_free then
      if mode_view.Down then vp.mdrag := MD_MOVE;
    end;
    mbRight  : begin
      if vp.view_type <> vt_free then      
        vp.mdrag := MD_MOVE
      else
        vp.mdrag := MD_ROTATE;
    end;
    mbMiddle : vp.mdrag  := MD_SCALE;
  end;
  vp.Mpos := Point(X, Y);

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

  // NODES CREATE only not free view
  if (button=mbleft) and (mode_nodes.Down) and (nodes_add.Down) and (vp.view_type <> vt_free) then begin
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

procedure Teditor_form.view_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  dx,dy,dz : extended;
  cur_point, cur_grid : tmy_vector;
  vp : tmy_viewport;
begin
  vp := get_view(sender as tpanel);
  if vp = nil then exit;
  {$region 'camera'}
  case vp.mdrag of
    MD_ROTATE :
      begin
        vp.Camera.Rot_X := vp.Camera.Rot_X - (Y - vp.Mpos.Y) * ROTATE_K;
        vp.Camera.Rot_Y := vp.Camera.Rot_Y - (X - vp.Mpos.X) * ROTATE_K;
      end;
    MD_SCALE  :
      vp.Camera.Scale := vp.Camera.Scale - (Y - vp.Mpos.Y) * SCALE_K;
    MD_MOVE:
      case vp.view_type of
        vt_free: begin
          if xy_btn.Down then begin
            vp.Camera.pos_x := vp.Camera.pos_x - (Y - vp.Mpos.Y) * MOVE_K / vp.Camera.Scale;
            vp.Camera.pos_z := vp.Camera.pos_z - (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
          end;
          if z_btn.Down then begin
            vp.Camera.pos_y := vp.Camera.pos_y + (Y - vp.Mpos.Y) * MOVE_K / vp.Camera.Scale;
          end;
        end;
        vt_left: begin
          vp.Camera.pos_y := vp.Camera.pos_y + (Y - vp.Mpos.Y) * MOVE_K / vp.Camera.Scale;
          vp.Camera.pos_x := vp.Camera.pos_x - (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
        end;
        vt_front: begin
          vp.Camera.pos_y := vp.Camera.pos_y + (Y - vp.Mpos.Y) * MOVE_K / vp.Camera.Scale;
          vp.Camera.pos_z := vp.Camera.pos_z - (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
        end;
        vt_top: begin
          vp.Camera.pos_z := vp.Camera.pos_z - (Y - vp.Mpos.Y) * MOVE_K / vp.Camera.Scale;
          vp.Camera.pos_x := vp.Camera.pos_x - (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
        end;
      end;
  end;
  {$endregion}

  // NODES SELECT
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_select.Down) then begin
    end_rect := point(X, Y);
    panel_rect := vp.form.view_panel;
  end;

  // NODES MOVE
  if (ssLeft in Shift) and (mode_nodes.Down) and (nodes_move.Down) and (truck.first_selected_node >= 0) then
  begin
  case vp.view_type of
    vt_free: begin
    if XY_move.Down then begin
      dx := (X - vp.Mpos.X) * MOVE_K / vp.camera.Scale;
      dy := -(Y - vp.Mpos.Y) * MOVE_K / vp.camera.Scale;
      dz := 0;
    end;
    if XZ_move.Down then begin
      dx := (X - vp.Mpos.X) * MOVE_K / vp.camera.Scale;
      dz := (Y - vp.Mpos.Y) * MOVE_K / vp.camera.Scale;
      dy := 0;
    end;
    if ZY_move.Down then begin
      dz := (X - vp.Mpos.X) * MOVE_K / vp.camera.Scale;
      dy := -(Y - vp.Mpos.Y) * MOVE_K / vp.camera.Scale;
      dx := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - vp.Mpos.X) * MOVE_K / vp.camera.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - vp.Mpos.X) * MOVE_K / vp.camera.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - vp.Mpos.X) * MOVE_K / vp.camera.Scale;
      dy := 0;
      dx := 0;
    end;

    end; // end free
    vt_left: begin
    if (not movex_btn.Down) and (not movey_btn.Down) and (not movez_btn.Down) then begin
      dx := (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
      dy := -(Y - vp.Mpos.Y) * MOVE_K / vp.Camera.Scale;
      dz := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - vp.Mpos.X) * MOVE_K / vp.Camera.Scale;
      dy := 0;
      dx := 0;
    end;
    end; // end left
    vt_front: begin
    if (not movex_btn.Down) and (not movey_btn.Down) and (not movez_btn.Down) then begin
      dz := (X - vp.mpos.X) * MOVE_K / vp.Camera.Scale;
      dy := -(Y - vp.mpos.Y) * MOVE_K / vp.Camera.Scale;
      dx := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - vp.mpos.X) * MOVE_K / vp.Camera.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - vp.mpos.X) * MOVE_K / vp.Camera.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - vp.mpos.X) * MOVE_K / vp.Camera.Scale;
      dy := 0;
      dx := 0;
    end;
    end;
    vt_top: begin
    if (not movex_btn.Down) and (not movey_btn.Down) and (not movez_btn.Down) then begin
      dx := (X - vp.mpos.X) * MOVE_K / vp.camera.Scale;
      dz := (Y - vp.mpos.Y) * MOVE_K / vp.camera.Scale;
      dy := 0;
    end;
    // ===============
    if movex_btn.Down then begin
      dx := (X - vp.mpos.X) * MOVE_K / vp.camera.Scale;
      dy := 0;
      dz := 0;
    end;
    if movey_btn.Down then begin
      dy := (X - vp.mpos.X) * MOVE_K / vp.camera.Scale;
      dx := 0;
      dz := 0;
    end;
    if movez_btn.Down then begin
      dz := (X - vp.mpos.X) * MOVE_K / vp.camera.Scale;
      dy := 0;
      dx := 0;
    end;
    end; // end top

  end; // end case

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

  vp.Mpos := Point(X, Y);
// ограничения камеры
  if vp.Camera.Rot_X > 90 then
    vp.Camera.Rot_X := 90;
  if vp.Camera.Rot_X < -90 then
    vp.Camera.Rot_X := -90;
  if vp.Camera.Scale < 0.1 then
    vp.Camera.Scale := 1;
end;

procedure Teditor_form.view_MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : integer;
  vp : tmy_viewport;
begin
  vp := get_view(sender as tpanel);
  if vp = nil then exit;

  vp.mdrag := MD_NONE;
  panel_rect := nil;

  // END SELECTING NODE
  if (mode_nodes.Down) and (nodes_select.Down) then
  for i := 0 to truck.num_nodes - 1 do
    if truck.nodes[i].highlight then begin
      truck.nodes[i].highlight := false;
      truck.nodes[i].selected := true;
    end;
end;

procedure Teditor_form.write_params;
var
  F : tinifile;
begin
  F := tinifile.Create(currpath+'options.ini');
  F.WriteInteger  ('main','edit_panel_width',custom_pages.Width);
  if self.WindowState = wsMaximized then
    F.WriteBool   ('main','window_max',     true)
  else
  begin
    F.WriteBool   ('main','window_max',     false);
    F.WriteInteger('main','window_width',   self.Width );
    F.WriteInteger('main','window_height',  self.height );
    F.WriteInteger('main','window_left',    self.Left );
    F.WriteInteger('main','window_top',     self.Top );
  end;

  F.Free;
end;

procedure Teditor_form.write_views;
var
  F : tinifile;
  i : integer;
begin
  F := tinifile.Create(currpath+'options.ini');
  F.WriteInteger('views','num', length(views));
  for i := 0 to length(views) - 1 do
    begin
      if not views[i].form.max then begin
        F.WriteInteger('views','view_'+inttostr(i)+'_form_left',    views[i].form.Left);
        F.WriteInteger('views','view_'+inttostr(i)+'_form_top',     views[i].form.top);
        F.WriteInteger('views','view_'+inttostr(i)+'_form_width',   views[i].form.width);
        F.WriteInteger('views','view_'+inttostr(i)+'_form_height',  views[i].form.height);
      end else begin
        F.WriteInteger('views','view_'+inttostr(i)+'_form_left',    views[i].form.old_rect.Left);
        F.WriteInteger('views','view_'+inttostr(i)+'_form_top',     views[i].form.old_rect.top);
        F.WriteInteger('views','view_'+inttostr(i)+'_form_width',   views[i].form.old_rect.Right);
        F.WriteInteger('views','view_'+inttostr(i)+'_form_height',  views[i].form.old_rect.Bottom);
      end;
      case views[i].view_type of
        vt_free : F.WriteInteger ('views','view_'+inttostr(i)+'_type', 0);
        vt_left : F.WriteInteger ('views','view_'+inttostr(i)+'_type', 1);
        vt_front : F.WriteInteger('views','view_'+inttostr(i)+'_type', 2);
        vt_top : F.WriteInteger  ('views','view_'+inttostr(i)+'_type', 3);
      end;
    end;
  F.Free;
end;

end.
