function [p]  = Qiteration(gamma,pr)
    Q1=zeros(6,2);
    Q = [0.0,0.0;1.0,0.625;0.5,1.25;0.625,2.5;1.25,5.0;0.0,0.0];
    conv = 0.00001;
    j=0;
    count = 0;
    n = [];
    while(j<10000000)
        if (sum(sum(abs(Q1-Q))) < conv) 
            count = count + 1;
            if (count > 500)
                break
            end
        else
            Q=Q1;
            count = 0;
        end
        j=j+1;
        for s1=1:6
            for a=1:2
                acc=0;
                for s2=1:6
                    acc = acc + P(s1,s2,a,pr)*(R(s1,s2,a) +gamma*(max(Q1(s2,:))));
                end
                Q1(s1,a) = acc;
            end
        end
        disp(j);
        disp(Q1);
    end
    p = zeros(6,1);
    for s1=1:6
        if Q1(s1,1) > Q1(s1,2) 
            p(s1) = -1;
        else
            p(s1) = 1;
        end
    end
end
