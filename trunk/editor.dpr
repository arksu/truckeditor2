program editor;

uses
  Forms,
  main in 'main.pas' {editor_form},
  truck_file in 'truck_file.pas',
  file_parser in 'file_parser.pas',
  gl_font in 'gl_font.pas',
  utils in 'utils.pas',
  view_unit in 'view_unit.pas' {view_form};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Teditor_form, editor_form);
  Application.Run;
end.
