function y = CustomCurveFitFunction(x,a,b,c)

     y = (1 +a*x + b*x.^2)./(c*x);

end