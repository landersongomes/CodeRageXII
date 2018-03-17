unit HeaderFooterTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.Objects, FMX.Controls.Presentation, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    btnCamera: TButton;
    btnGaleria: TButton;
    btnEnviar: TButton;
    Image1: TImage;
    ActionList1: TActionList;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure btnCameraClick(Sender: TObject);
    procedure btnGaleriaClick(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure btnEnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HeaderFooterForm: THeaderFooterForm;

implementation

{$R *.fmx}
uses System.JSON, System.NetEncoding, REST.Utils, REST.Types;

procedure THeaderFooterForm.btnCameraClick(Sender: TObject);
begin
  TakePhotoFromCameraAction1.Execute;
end;

procedure THeaderFooterForm.btnEnviarClick(Sender: TObject);
var
  lMemoria : TMemoryStream;
  lStrEnv : TStringStream;
  lJOImagem : TJSonObject;
begin
  lMemoria := TMemoryStream.Create;
  Image1.Bitmap.SaveToStream(lMemoria);
  lMemoria.Position := 0;
  lStrEnv := TStringStream.Create;
  TNetEncoding.Base64.Encode(lMemoria, lStrEnv);
  lStrEnv.Position := 0;
  lJOImagem := TJSONObject.Create;
  lJOImagem.AddPair('arquivo', lStrEnv.DataString);

  //Configurando REST Client
  RESTClient1.ResetToDefaults;
  RESTResponse1.ResetToDefaults;
  RESTRequest1.ResetToDefaults;
  RESTClient1.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient1.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient1.BaseURL := Format('http://%s:%s/datasnap/rest', ['192.168.0.135', '8080']);
  RESTClient1.ContentType := 'application/json';
  RESTClient1.HandleRedirects := True;
  RESTClient1.RaiseExceptionOn500 := False;
  RESTRequest1.Client := RESTClient1;

  RESTRequest1.Params.AddItem('aJsonO', lJOImagem.ToString, TRESTRequestParameterKind.pkREQUESTBODY,
  [poDoNotEncode],
  ctAPPLICATION_JSON);
  RESTRequest1.Resource := 'TServerMethods1/Imagem';
  RESTRequest1.Response := RESTResponse1;
  RESTRequest1.Method := rmPOST;
  RESTRequest1.SynchronizedEvents := False;
  RESTRequest1.Execute;


end;

procedure THeaderFooterForm.btnGaleriaClick(Sender: TObject);
begin
  TakePhotoFromLibraryAction1.Execute;
end;

procedure THeaderFooterForm.TakePhotoFromCameraAction1DidFinishTaking(
  Image: TBitmap);
begin
  Image1.Bitmap.Assign(Image);
end;

procedure THeaderFooterForm.TakePhotoFromLibraryAction1DidFinishTaking(
  Image: TBitmap);
begin
  Image1.Bitmap.Assign(Image);
end;

end.
