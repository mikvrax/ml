function [p]  = Qlearning(gamma,pr,e,alpha)
    Q1=zeros(6,2);
    Q = [0.0,0.0;1.0,0.625;0.5,1.25;0.625,2.5;1.25,5.0;0.0,0.0];
    conv = 0.00001;
    j=0;
    while  (sum(sum(abs(Q-Q1))) > conv)
        if j==10000
            break
        end
        j=j+1;
        for s1=1:6
                [m,a] = max(Q1(s1,:)); 
                if (rand() < e)
                    if (rand() > 0.5)
                        a = 1;
                    else
                        a = 2;
                    end
                end
                if (s1==1) || (s1==6)
                    s2=s1;
                    r = 0;
                else
                    if (a==1)
                        s2=s1-1;
                    else
                        s2=s1+1;
                    end
                    if (s2 ==1)
                        r=1;
                    elseif (s2==6)
                        r=5;
                    else
                        r=0;
                    end
                    if rand() < pr
                        s2=s1;
                        r=0;
                    end
                end
                m = max(Q1(s2,:));
                Q1(s1,a) = Q1(s1,a) +alpha*(r + gamma*m - Q1(s1,a)); 
        end
        n(j) = norm(Q-Q1,2);
        disp(j);
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
