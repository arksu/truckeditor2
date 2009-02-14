unit gl_font;

interface

uses
  Windows, OpenGL;

type
  Tgl_font = class ( tobject )
  public
    font_name : string;
    size : integer;
    inited : boolean;
    procedure Init;
    procedure finit;
  private
    ID : LongWord;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure Print(X, Y: Integer; const Text: string); overload;
    procedure Print(X, Y, Z: extended; const Text: string); overload;
  end;

implementation

procedure Tgl_font.Init;
var
  Font : HFONT;
  DC   : HDC;
begin
  if inited then exit;
  if (font_name = '') or (size = 0) then exit;
  
  
  ID := glGenLists(256);
  Font := CreateFont(Size, 0, 0, 0, FW_NORMAL, 0, 0, 0,
                     ANSI_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
                     ANTIALIASED_QUALITY, DEFAULT_PITCH, PChar(font_name  ));
  DC := GetDC(0);
  SelectObject(DC, Font);
  wglUseFontBitmaps(DC, 0, 256, ID);
  DeleteObject(Font);
  ReleaseDC(0, DC);
  inited := true;
end;

procedure Tgl_font.Print(X, Y, Z: extended; const Text: string);
begin
  if not inited then exit;
  
  glRasterPos3f(X, Y, Z);
  glListBase(ID);
  glCallLists(Length(Text), GL_UNSIGNED_BYTE, PChar(Text));
end;

constructor Tgl_font.Create;
begin
  inited := false;
  font_name := '';
  size := 0;
end;

destructor Tgl_font.Destroy;
begin
  if inited then finit;

end;

procedure Tgl_font.finit;
begin
  glDeleteLists(ID, 256);
end;

procedure Tgl_font.Print(X, Y: Integer; const Text: string);
begin
  if not inited then exit;

  glRasterPos2i(X, Y);
  glListBase(ID);
  glCallLists(Length(Text), GL_UNSIGNED_BYTE, PChar(Text));
end;

end.
