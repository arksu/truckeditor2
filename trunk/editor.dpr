program editor;

uses
  Forms,
  main in 'main.pas' {editor_form},
  truck_file in 'truck_file.pas',
  file_parser in 'file_parser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Teditor_form, editor_form);
  Application.Run;
end.
