unit view_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  gl_font;

type
  Tview_form = class;
  
  tmy_camera = record
      Rot_X, Rot_Y : Single;
      Scale : Single;
      pos_x, pos_y, pos_z : single;
  end;

  tviewport_type = (vt_free, vt_left, vt_front, vt_top);
  tmy_drag = (MD_NONE, MD_MOVE, MD_ROTATE, MD_SCALE);
  tmy_move_mode = (MM_XY, MM_XZ, MM_ZY);

  Tmy_viewport = class (tobject)
    DC            : HDC;
    RC            : HGLRC;
    Camera        : tmy_camera;
    view_type     : tviewport_type;
    mdrag         : tmy_drag;
    Mpos          : TPoint;
    form          : Tview_form;
    nodes_font    : Tgl_font;

    procedure init_gl;
    procedure init;
    procedure init_cam;

    procedure finit_gl;

    constructor Create ;
    destructor Destroy; override;
  end;

  Tview_form = class(TForm)
    view_panel: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    vp : Tmy_viewport;
  end;

implementation

uses main;

{$R *.dfm}

procedure Tview_form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  editor_form.delete_view(self);
end;

procedure Tview_form.FormResize(Sender: TObject);
begin
  if vp = nil then exit;

  editor_form.render_view(
    vp.DC,
    vp.RC,
    view_panel,
    vp.Camera
  );
end;


{ Tmy_viewport }

constructor Tmy_viewport.Create;
begin
  nodes_font := tgl_font.Create;
end;

destructor Tmy_viewport.Destroy;
begin
  nodes_font.Free;
end;

procedure Tmy_viewport.finit_gl;
begin
  wglDeleteContext(RC);
  ReleaseDC(form.view_panel.Handle,DC);
  DeleteDC(DC);
end;

procedure Tmy_viewport.init;
begin
  case view_type of
    vt_free:  form.Caption := 'Free view';
    vt_left:  form.Caption := 'Left view';
    vt_front: form.Caption := 'Front view';
    vt_top:   form.Caption := 'Top view';
  end;
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
  DC := GetDC(form.view_panel.Handle);

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
