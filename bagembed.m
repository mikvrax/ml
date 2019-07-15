function [m] = bagembed(B,sigma,dat)
    % initialize feature vector and distances array
    N_instances = size(dat,1);
    N_bag_instances = size(B,1);
    m = nan(N_instances,1);
    s = nan(N_instances,N_bag_instances);
    
    % compute for each bag instance the distance to all other instances
    for i=1:N_instances
        instance = +dat(i,:);
        for j=1:N_bag_instances
            dist = norm(B(j,:) - instance);
            s(i,j) = exp(-1* dist*dist/(sigma*sigma));
        end
        % use only the maximum distance
        m(i) = max(s(i,:));
    end
end
