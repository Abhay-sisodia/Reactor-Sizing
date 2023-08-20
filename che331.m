syms x
% y = (1 +a*x + b*x.^2)./(c*x);
CAo =[2,5,6,6,11,14,16,24];
Ca =[0.5,3,1,2,6,10,8,4];
tow =[30,1,50,8,4,20,20,4];
rate = zeros(1, 8);
for i = 1:8
rate(i) = tow(i)/(CAo(i)-Ca(i));
end
ft = fittype('CustomCurveFitFunction(x, a, b, c)');
f = fit(Ca(:), rate(:), ft);
coeff = coeffvalues(f);
a=coeff(1);
b=coeff(2);
c=coeff(3);
%  Value of a is coming =-0.4714
%  Value of b is coming  = 0.0689
%  Value of c is coming =0.0751

y = simplify((1 -0.4714*x + 0.0689*x.^2)./(0.0751*x));
F = input('Enter flow rate : ');
C0 = input('Enter initial concentration : ');
Ct = input('Enter final concentration : ');
t = input('Enter type of reactor you want from 1 to 5: ');
area = zeros(1, 100);

% Plotting the curve
ezplot(y,[C0,Ct]);
% xlim([0.1 20]);
% hold on
% scatter(Ca,rate);
xlabel('C_a');
ylabel('1/(-r_a)');

if t==1
ran=Ct:0.0001:C0;
y_ran= ((1 -0.4714*ran + 0.0689*ran.^2)./(0.0751*ran));
Area=trapz(ran,y_ran);
V=Area*F;
end
if t==2
V = (C0-Ct)*F*(subs(y,Ct));
V=double(V);
end
if t==3
ci=1;
for i=1:100
area1=(ci-Ct)*(subs(y,Ct));
area2=(C0-ci)*(subs(y,ci));
area(i)=area1+area2;
ci=ci+0.1;
end
min_area=min(area);
V=min_area*F;
end
if t==4
ran=Ct:0.0001:C0;
y_ran= ((1 -0.4714*ran + 0.0689*ran.^2)./(0.0751*ran));
[min_value ,index]=min(y_ran);
min_x=Ct+(0.0001*index);
ran2=Ct:0.0001:min_x;
y_ran2= ((1 -0.4714*ran2 + 0.0689*ran2.^2)./(0.0751*ran2));
val_1=trapz(ran2,y_ran2);
val_2=(C0-min_x)*abs(min_value);
V=(val_1+val_2)*F;
end
if t==5
my_val=100000;
my_idx=0;

for i = Ct+0.1: 0.5: C0
y_i= ((1 -0.4714*i + 0.0689*i.^2)./(0.0751*i));
denom_1=(i-Ct);

ran=Ct:0.0001:i;
y_ran= ((1 -0.4714*ran + 0.0689*ran.^2)./(0.0751*ran));
Area=trapz(ran,y_ran);
area=double(Area/denom_1);
fin_val=abs(y_i-area);

if fin_val<my_val
my_val=fin_val;
my_idx=i;
end
Reflux_rate=(C0-my_idx)/(my_idx-Ct);
y_val=double(subs(y,my_idx));
V=double(F*y_val*(C0-Ct));
end


end
