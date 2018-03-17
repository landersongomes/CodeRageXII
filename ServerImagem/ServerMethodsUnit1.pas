unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    DataSnap.DSProviderDataModuleAdapter,
    Datasnap.DSServer, Datasnap.DSAuth;

type
  TServerMethods1 = class(TDSServerModule)
  private
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function UpdateImagem (aJsonO : TJSONObject) : boolean;
  end;

implementation


{$R *.dfm}


uses System.StrUtils, System.NetEncoding;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.UpdateImagem(aJsonO: TJSONObject): boolean;
var
  lInStream : TStringStream;
  lOutStream : TMemoryStream;
begin
  lInStream := TStringStream.Create(aJsonO.GetValue('arquivo').Value);
  lInStream.Position := 0;
  lOutStream := TMemoryStream.Create;
  TNetEncoding.Base64.Decode(lInStream, lOutStream);
  lOutStream.Position := 0;
  lOutStream.SaveToFile('coderage.jpg');
  Result := True;

end;

end.

