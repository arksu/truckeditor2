unit properties_unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  Tproperties_form = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    name_edit: TLabeledEdit;
    ffversion_edit: TLabeledEdit;
    Label1: TLabel;
    desc_memo: TMemo;
    help_edit: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    TabSheet2: TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  properties_form: Tproperties_form;

implementation

{$R *.dfm}

end.
