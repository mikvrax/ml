function [reward] = R(s1,s2,a)
      if (s1==1) || (s1==6)
           s2=s1;
           reward = 0;
      else
           if (a==1)
              s2=s1-1;
           else
              s2=s1+1;
           end
           if (s2 ==1)
                reward=1;
           elseif (s2==6)
                reward=5;
           else
                reward=0;
           end
      end
end
