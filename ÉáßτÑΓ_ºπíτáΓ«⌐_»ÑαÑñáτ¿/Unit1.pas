unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    GroupBox5: TGroupBox;
    Label58: TLabel;
    Edit1: TEdit;
    Label59: TLabel;
    Edit2: TEdit;
    Label60: TLabel;
    Label61: TLabel;
    Edit3: TEdit;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    GroupBox6: TGroupBox;
    Label69: TLabel;
    Edit4: TEdit;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Edit5: TEdit;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Edit6: TEdit;
    Image1: TImage;
    BitBtn1: TBitBtn;
    Image2: TImage;
    BitBtn2: TBitBtn;
    Label96: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses math;
const rr=3;

var mas,rof:double;
     x01,y01,x02,y02:integer;
     
//эвольвентная функция inv(a)=tg(a)-a
function inv(a:double):double;
begin
inv:=tan(a)-a;
end;

function arcinv(inva:double):double;
var rab1:double;
begin
result:=pi/9; rab1:=0;
 while abs(rab1-result)>1.0e-15 do
 begin
  rab1:=result;
  result:=arctan(result+inva);
 end;
end;

procedure evol(rb,alfa:double; var  R,teta:double);
begin
 R:=rb/cos(alfa);
 teta:=inv(alfa);
end;

procedure Evolxy(rb,teta,gamma:double; var x,y:double);
var alfa,R:double;
begin
alfa:=arcinv(teta);
r:=rb/cos(alfa);
x:=r*cos(teta+gamma);
y:=r*sin(teta+gamma);
end;

procedure Evolxy2(rb,alfa,gamma:double; var x,y:double);
var teta,r:double;
begin
teta:=inv(alfa);
r:=rb/cos(alfa);
x:=r*cos(teta+gamma);
y:=r*sin(teta+gamma);
end;

procedure circle(Can:Tcanvas; X0,Y0,R:integer);
begin
 can.Ellipse(X0-R,Y0-R,X0+R,Y0+R);
end;

type Tarc=record
x3,y3,x4,y4:integer;
end;
var arcp:Tarc;
procedure arc(Can:Tcanvas; X0,Y0,R:integer; fib,fie:double);
begin
with arcp do
begin
 x3:=X0+round(R*cos(fib));
 y3:=Y0-round(R*sin(fib));
 x4:=X0+round(R*cos(fie));
 y4:=Y0-round(R*sin(fie));
 can.arc(X0-R,Y0-R,X0+R,Y0+R,x3,y3,x4,y4);
end;
end;

//определение alfw
function find_alfw(alf,xs,zs:double; flag:boolean=true):double;
var rab:double;
begin
rab:=inv(alf)+2*xs/zs*tan(alf);
if not flag then
begin
 result:=rab; exit;
end;
result:=arcinv(rab);
end;

//определение толщины зуба по любой окружности
function Find_Sw(s,r,rw,alfw:double; alf:double=pi/9):double;
begin
result:=rw*(s/r+2*(inv(alf)-inv(alfw)));
end;

type
TParZub2=record  //запись для колеса
r,rb,rw,rf,ra,tay,x,s,sa,alf_a:double;
end;
TParZub=record  //запись для передачи
aw,alfw,epsalf:double;
end;

var m,m1,U1H:double; Z1,Z2,K,n:integer;
    Zub1,Zub2:TParZub2;
    ZubT:TparZub;

// параметры внешнего зубчатого зацепления
procedure Zac(m:double; z1,z2:integer; var Zw1,Zw2:TParZub2;
var Zt:TParZub; aw:double=0; alf:double=pi/9);
var rr,rab1,rab2,co,ta,sz:double;
begin
rr:=0.5*m;
//радиусы делительных окружностей
Zw1.r:=rr*z1;  Zw2.r:=rr*z2;
co:=cos(alf);
//радиусы основных окружностей
Zw1.rb:=Zw1.r*co;  Zw2.rb:=Zw2.r*co;
//угловые шаги
Zw1.tay:=2*pi/z1;  Zw2.tay:=2*pi/z2;
sz:=z1+z2;  ta:=tan(alf);

if aw<>0 then
begin //если задано межосевое расстояние
 Zt.aw:=aw;
 //угол зацепления
 Zt.alfw:=arccos(rr*sz*co/aw);
 rab2:=cos(Zt.alfw);
 //суммарный коэффициет смещения x1+x2
 rab1:=(inv(Zt.alfw)-inv(alf))*sz/2/ta;
 //коэффициеты смещения
 Zw1.x:=(17-z1)/17; Zw2.x:=rab1-Zw1.x;
end
else
begin
//коэффициеты смещения
 Zw1.x:=(17-z1)/17; Zw2.x:=0;
 //Zw1.x:=0.228; Zw2.x:=0.023;
 //нахождение угла зацепления alfw
 Zt.alfw:=find_alfw(alf,Zw1.x+Zw2.x,sz);
 rab2:=cos(Zt.alfw);
 //межосевое расстояние
 Zt.aw:=rr*sz*co/rab2;
end;

//радиусы начальных окружностей
Zw1.rw:=Zw1.rb/rab2;  Zw2.rw:=Zw2.rb/rab2;
//радиусы окружностей впадин
Zw1.rf:=rr*(z1-2.5+2*Zw1.x); Zw2.rf:=rr*(z2-2.5+2*Zw2.x);
//радиусы окружностей вершин
Zw1.ra:=Zt.aw-Zw2.rf-0.25*m; Zw2.ra:=Zt.aw-Zw1.rf-0.25*m;
//толшина зуба по делительной окружности
Zw1.s:=m*(pi/2+2*Zw1.x*ta);  Zw2.s:=m*(pi/2+2*Zw2.x*ta);
rab1:=arccos(Zw1.rb/Zw1.ra);
Zw1.alf_a:=rab1;
rab2:=arccos(Zw2.rb/Zw2.ra);
Zw2.alf_a:=rab2;
ta:=tan(Zt.alfw);
//коэффициент перекрытия
Zt.epsalf:=(tan(rab1)-ta)/Zw1.tay+(tan(rab2)-ta)/Zw2.tay;
//толщина зуба у вершины
Zw1.sa:=Find_Sw(Zw1.s,Zw1.r,Zw1.ra,rab1);
Zw2.sa:=Find_Sw(Zw2.s,Zw2.r,Zw2.ra,rab2);
end;

type TPlan=record
Z1,Z2,Z3,Z2s,K:integer;
r1,r2,r3,r2s,u1H:double;
end;
//синтез планетарного редуктора №1
procedure SinPlan1(m,U1Hn:double; var Zr:Tplan; nst:integer=1;
dU:double=2; K:integer=0);
label m1;
var u13,u12,u23,saw2,Z1min,Z2min,r,U1H:double;
    k1,sz:integer;
begin
 saw2:=sqr(sin(pi/9));
 if nst>1 then u13:=Power(U1Hn,1/nst) else u13:=U1Hn;
 U1H:=u13;
 u13:=abs(1-u13);
 u12:=abs(u13-1)/2;
 u23:=u13/u12;
 Z1min:=2*(sqrt(sqr(u12)+(2*u12+1)*saw2)+u12)/((2*u12+1)*saw2);
 Z2min:=2*(sqrt(sqr(u23)-(2*u23-1)*saw2)+u23)/((2*u23-1)*saw2);
 Z1min:=Ceil(Z1min);
 Z2min:=Ceil(Z2min);
 //Вычисление чисел зубьев Z1,Z2,Z3
 Zr.Z1:=round(Z1min);
 m1:
 while true do
 begin
  r:=u12*Zr.Z1;
  if r>Z2min then break;
  inc(Zr.Z1);
 end;
 Zr.Z2:=Ceil(r);
 with Zr do
 begin
  Z3:=Z1+2*Z2;
  u1H:=1+Z3/Z1;
  r1:=0.5*m*z1;
  r2:=0.5*m*z2;
  r3:=0.5*m*z3;
  sz:=Z1+Z3;
 end;
 if K<>0 then  //если задано число сателлитов
 begin
  if K>2 then
  begin
   r:=sin(pi/K);
   r:=(r*Zr.Z1-2)/(1-r);
  end;
 end;
 if abs(U1H-Zr.u1H)*100>du then
 begin
  inc(Zr.Z1);
  goto m1;
 end;
 //число сателлитов К
 r:=(Zr.Z2+2)/(Zr.Z1+Zr.Z2);
 r:=pi/arcsin(r);
 if K=0 then
 for k1:=trunc(r) downto 1 do
  if  (sz div k1)*k1=sz then
  begin Zr.K:=k1; break; end;
 if K<>0 then
 begin
  Zr.K:=K;
 end;
 end;

var pl:Tplan;
procedure TForm1.Button1Click(Sender: TObject);
begin
bitbtn1.Enabled:=true;
bitbtn2.Enabled:=true;
m:=strtofloat(Edit1.Text);
Z1:=strtoint(edit2.Text);
Z2:=strtoint(edit3.Text);
m1:=strtofloat(Edit4.Text);
U1H:=strtofloat(Edit5.Text);
n:=strtoint(Edit6.Text);

zac(m,z1,z2,Zub1,Zub2,ZubT);

label1.Caption:=format('%0.2f',[ZubT.alfw*180/pi]);
label2.Caption:=format('%0.3f мм',[ZubT.aw]);
label7.Caption:=format('%0.3f',[ZubT.epsalf]);

label10.Caption:=format('%0.3f мм',[Zub1.r]);
label13.Caption:=format('%0.3f мм',[Zub2.r]);        
label16.Caption:=format('%0.3f мм',[Zub1.rb]);
label19.Caption:=format('%0.3f мм',[Zub2.rb]);
label22.Caption:=format('%0.3f мм',[Zub1.rw]);
label25.Caption:=format('%0.3f мм',[Zub2.rw]);
label28.Caption:=format('%0.3f мм',[Zub1.rf]);
label31.Caption:=format('%0.3f мм',[Zub2.rf]);
label34.Caption:=format('%0.3f мм',[Zub1.ra]);
label37.Caption:=format('%0.3f мм',[Zub2.ra]);
label40.Caption:=format('%0.3f мм',[Zub1.s]);
label43.Caption:=format('%0.3f мм',[Zub2.s]);
label46.Caption:=format('%0.3f',[Zub1.tay*180/pi]);
label49.Caption:=format('%0.3f',[Zub2.tay*180/pi]);
label52.Caption:=format('%0.3f',[Zub1.x]);
label55.Caption:=format('%0.3f',[Zub2.x]);
label63.Caption:=format('%0.3f мм',[Zub1.sa]);
label66.Caption:=format('%0.3f мм',[Zub2.sa]);

Sinplan1(m1,U1H,pl,n);
label86.Caption:=format('%d',[pl.Z1]);
label87.Caption:=format('%d',[pl.Z2]);
label88.Caption:=format('%d',[pl.Z3]);
label89.Caption:=format('%0.1f мм',[Pl.r1]);
label90.Caption:=format('%0.1f мм',[Pl.r2]);
label91.Caption:=format('%0.1f мм',[Pl.r3]);
label92.Caption:=format('%d',[Pl.K]);
label94.Caption:=format('%0.1f%s',[abs(power(Pl.u1H,n)-U1H)*100,' %']);



end;

procedure TForm1.FormCreate(Sender: TObject);
begin
decimalseparator:='.';
image1.Canvas.Rectangle(rect(0,0,image1.Width,image1.Height));
end;

procedure DrawCircles(x01,y01:integer; Zub1:TParzub2);
begin
 with form1.Image1 do
 begin
 canvas.Pen.Color:=clteal;
 circle(Canvas,x01,y01,round(mas*Zub1.ra));
 canvas.Pen.Color:=clmaroon;
 circle(canvas,x01,y01,round(mas*Zub1.r));
 canvas.Pen.Color:=clfuchsia;
 circle(canvas,x01,y01,round(mas*Zub1.rb));
 canvas.Pen.Color:=claqua;
 circle(canvas,x01,y01,round(mas*Zub1.rf));
 canvas.Pen.Color:=clblack;
 circle(canvas,x01,y01,round(mas*Zub1.rw));
 circle(canvas,x01,y01,rr);
 end;
end;

procedure DrawZub(gam:double; x01,y01:integer; Zub1:TParzub2);
const n=16;
var t,ht,x,y,l:double;
    Pb,Pf,Pa,Pbs,Pfs,Pas,P:Tpoint;
begin
with form1 do
begin
 t:=0;
 ht:=Zub1.alf_a/n;
 while t<=Zub1.alf_a+ht/2 do
 begin
  Evolxy2(Zub1.rb,t,gam,x,y);
  if t=0 then
  begin
  image1.Canvas.MoveTo(x01+round(mas*x),y01-round(mas*y));
  Pb:=image1.Canvas.PenPos;
  end
  else
  image1.Canvas.lineTo(x01+round(mas*x),y01-round(mas*y));
  t:=t+ht;
 end;
  Pa:=image1.Canvas.PenPos;
  image1.Canvas.MoveTo(Pb.X,Pb.Y);
  Pf.X:=Pb.X-round(mas*(Zub1.rb-Zub1.rf-rof)*cos(gam));
  Pf.y:=Pb.y+round(mas*(Zub1.rb-Zub1.rf-rof)*sin(gam));
  image1.Canvas.LineTo(Pf.X,Pf.Y);

 t:=find_sw(Zub1.s,Zub1.r,1,0);
 l:=Zub1.tay-t;
 P.X:=X01+round(mas*Zub1.rf*cos(gam-l/2));
 P.y:=y01-round(mas*Zub1.rf*sin(gam-l/2));
 image1.Canvas.LineTo(P.X,P.Y);
 
 gam:=gam+t; t:=0;
 while t<=Zub1.alf_a+ht/2 do
 begin
  Evolxy2(Zub1.rb,-t,gam,x,y);
  if t=0 then
  begin
  image1.Canvas.MoveTo(x01+round(mas*x),y01-round(mas*y));
  Pbs:=image1.Canvas.PenPos;
  end
  else
  image1.Canvas.lineTo(x01+round(mas*x),y01-round(mas*y));
  t:=t+ht;
 end;
 Pas:=image1.Canvas.PenPos;
  image1.Canvas.MoveTo(Pbs.X,Pbs.Y);
  Pfs.X:=Pbs.X-round(mas*(Zub1.rb-Zub1.rf-rof)*cos(gam));
  Pfs.y:=Pbs.y+round(mas*(Zub1.rb-Zub1.rf-rof)*sin(gam));
  image1.Canvas.LineTo(Pfs.X,Pfs.Y);
  P.X:=X01+round(mas*Zub1.rf*cos(gam+l/2));
  P.y:=y01-round(mas*Zub1.rf*sin(gam+l/2));
  image1.Canvas.LineTo(P.X,P.Y);

  image1.Canvas.MoveTo(Pa.X,Pa.Y);
  image1.Canvas.LineTo(Pas.X,Pas.Y);
end;
end;

 procedure init;
 begin
 with form1.image1.Canvas do
 begin
  Pen.Style:=pssolid;
  pen.Color:=clblack;
  pen.Width:=1;
  Brush.Style:=bssolid;
  Brush.Color:=clWhite;
 end;
 end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var gam,iaw,sig:double; i,im:integer;
    PA,PB,P:Tpoint;
begin
init;
 image1.Canvas.Rectangle(rect(0,0,image1.Width,image1.Height));
//центры окружностей
 x01:=rr; y01:=image1.Height-rr;
 y02:=rr; x02:=image1.Width-rr;
//угол наклона межосевой линии
 sig:=arctan((y01-y02)/(x02-x01));
//рисуем межосевую линию
 image1.Canvas.Pen.Style:=psdashdot;
 image1.Canvas.MoveTo(x01,y01);
 image1.Canvas.lineTo(x02,y02);
 image1.Canvas.Pen.Style:=pssolid;
//считаем масштаб
 Iaw:=hypot(x02-x01,y02-y01);
 mas:=Iaw/ZubT.aw;

  image1.Canvas.Brush.Style:=bsclear;
//рисуем все окружности
 drawcircles(x01,y01,Zub1);
 drawcircles(x02,y02,Zub2);
//рисуем линию зацепления
PA.X:=x01+round(mas*Zub1.rb*cos(sig+ZubT.alfw));
PA.y:=y01-round(mas*Zub1.rb*sin(sig+ZubT.alfw));
circle(image1.Canvas,PA.x,PA.Y,rr);
PB.X:=x02+round(mas*Zub2.rb*cos(pi+sig+ZubT.alfw));
PB.y:=y02-round(mas*Zub2.rb*sin(pi+sig+ZubT.alfw));
circle(image1.Canvas,PB.x,PB.Y,rr);
image1.Canvas.MoveTo(x01,y01);
image1.Canvas.Pen.Color:=cllime;
image1.Canvas.lineTo(PA.x,PA.y);
image1.Canvas.Pen.Color:=clpurple;
image1.Canvas.lineTo(PB.x,PB.y);
image1.Canvas.Pen.Color:=cllime;
image1.Canvas.lineTo(x02,y02);

 rof:=0.4*m; //радиус галтели
 rof:=0;
 iaw:=inv(ZubT.alfw);

//рисуем зубья колеса 1
 image1.Canvas.Pen.Width:=3;
 image1.Canvas.Pen.Color:=clred;
 gam:=sig-iaw;

 im:=2;
 for i:=-im to im do
 drawZub(gam+i*Zub1.tay,x01,y01,zub1);
{
 image1.Canvas.Brush.Style:=bssolid;
 image1.Canvas.Brush.Color:=clyellow;
 image1.Canvas.FloodFill(x01+10,y01-10,clred,fsborder);
}
//рисуем зубья колеса 2
 image1.Canvas.Pen.Color:=clblue;
 gam:=sig-pi-iaw;

 im:=3;
 for i:=-im to im do
 drawZub(gam+i*Zub2.tay,x02,y02,zub2);
{
 image1.Canvas.Brush.Style:=bssolid;
 image1.Canvas.Brush.Color:=clyellow;
 image1.Canvas.FloodFill(x02-10,y02+10,clblue,fsborder);
}
//рисуем стрелки
with image1.Canvas do
begin
 Pen.Width:=2;
 unit1.arc(image1.Canvas,x02,y02,150,3.4,4.3);
 MoveTo(arcp.x4,arcp.y4);
 lineTo(arcp.x4-10,arcp.y4-2);
 MoveTo(arcp.x4,arcp.y4);
 lineTo(arcp.x4-7,arcp.y4-10);
 font.Name:='symbol';
 font.Size:=16;
 TextOut(PenPos.X+12,Penpos.Y,'w');
 font.Size:=10;
 TextOut(PenPos.X,Penpos.Y+14,'2');

 Pen.Color:=clred;
 unit1.arc(image1.Canvas,x01,y01,150,0.2,1.3);
 MoveTo(arcp.x3,arcp.y3);
 lineTo(arcp.x3,arcp.y3-10);
 MoveTo(arcp.x3,arcp.y3);
 lineTo(arcp.x3-7,arcp.y3-10);
 font.Size:=16;
 TextOut(PenPos.X+12,Penpos.Y,'w');
 font.Size:=10;
 TextOut(PenPos.X,Penpos.Y+14,'1');
 end;
end;


procedure TForm1.BitBtn2Click(Sender: TObject);
var i:integer;
    bet,RH:double;
begin
 init;
 image1.Canvas.Rectangle(rect(0,0,image1.Width,image1.Height));
 mas:=(min(image1.Width,image1.Height)-200)/Pl.r3/2;
 x01:=image1.Width div 2;
 y01:=image1.Height div 2;
 image1.Canvas.Brush.color:=clActiveBorder;
 //image1.Canvas.Pen.Color:=clred;
 image1.Canvas.Pen.Width:=2;
 
 //circle(image1.Canvas,x01,y01,2*rr);
 circle(image1.Canvas,x01,y01,round(mas*Pl.r3));
 image1.Canvas.Brush.color:=clMoneyGreen;
 circle(image1.Canvas,x01,y01,round(mas*Pl.r1));
 RH:=Pl.r1+Pl.r2;
 bet:=2*pi/Pl.K;
 //image1.Canvas.Brush.Style:=bssolid;
 image1.Canvas.Brush.color:=clskyblue;
 for i:=1 to Pl.K do
 begin
  x02:=x01+round(mas*RH*sin(bet*(i-1)));
  y02:=y01-round(mas*RH*cos(bet*(i-1)));
  circle(image1.Canvas,x02,y02,round(mas*Pl.r2));
  image1.Canvas.Pen.Width:=4;
  image1.Canvas.MoveTo(x01,y01);
  image1.Canvas.lineTo(x02,y02);
  image1.Canvas.Pen.Width:=2;
  circle(image1.Canvas,x02,y02,3*rr);
 end;
 circle(image1.Canvas,x01,y01,3*rr);
end;

end.
