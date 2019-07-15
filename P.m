function [prob] = P(s1,s2,a,pr)
    prob = 0;
    if s1 == 1
        if s2==s1
            prob = 1;
        end
    elseif s1 == 6
        if s2==s1
            prob=1;
        end
    else
        if (s2==s1+1) && (a==2)
            prob=1 - pr;
        elseif (s2==s1-1) && (a==1)
            prob=1 - pr;
        elseif s1==s2
            prob=pr;
        end
    end
end
