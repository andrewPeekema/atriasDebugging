function a = cosineFun(x1, x2, y1, y2, x, dx)
% Clamp
if x1 < x2
    if x < x1
        x = x1;
    elseif x > x2
        x = x2;
    end
else
    if x > x1
        x = x1;
    elseif x < x2
        x = x2;
    end
end
    

s = (1.0 - cos((x - x1)/(x2 - x1)*pi))/2.0;
a.y = y1*(1.0 - s) + y2*s;

ds = -(pi*sin((pi*(x1 - x))/(x1 - x2))*dx)/(2.0*(x1 - x2));
a.dy = -y1*ds + y2*ds;

end