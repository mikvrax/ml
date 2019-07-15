function [p]= Pol_it(gamma,pr)
    Q1=zeros(6,2);
    Q = [0.0,0.0;1.0,0.625;0.5,1.25;0.625,2.5;1.25,5.0;0.0,0.0];
    conv = 0.00001;
    p = ones(6,1);
    i=0;
    d=1;
    while  (sum(sum(abs(Q-Q1))) > conv)
        while d > conv  
            d = 0;
            for s1=1:6
                for a=1:2
                    q = Q(s1,a);
                    acc = 0;
                    for s2=1:6
                       acc = acc + P(s1,s2,p(s1),pr)*(R(s1,s2,p(s1)) + gamma*Q(s2,p(s1)));
                    end
                    Q(s1,a) = acc;
                end
                d = max(d,abs(q-Q1(s1,a)));
            end
        end
        stable = 1;
        for s1=1:6
            b = p(s1);
            acc = zeros(2,1);
            for a=1:2
                for s2=1:6
                    acc(a) = acc(a) + P(s1,s2,a,pr)*(R(s1,s2,a) + gamma*Q(s2,a));
                end
            end
            if acc(1) > acc(2)
                p(s1) = 1;
            else
                p(s1) = 2;
            end
            if b~=p(s1) 
                stable = 0;
            end
        end
        if stable == 1
            break
        end
        i=i+1;
        disp(i);
        disp(Q1);
    end    
    i=i+1;
    disp(i);
    disp(Q1); 
end
