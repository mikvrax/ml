function [bags,labels] = dataset2bags(dat)
    % get the relation between instance and bag
    bagids = getident(dat,'milbag');
    N_instances = size(dat,1);
    instance_labels = getlab(dat);
    N_bags = size(unique(bagids),1);
    labels = nan(N_bags,1);
    
    % initialize each bag
    for i=1:N_bags
        bags{i} = [];
    end
    % store the correspodning instances to the right bag
    for i=1:N_instances
        bags{bagids(i)} = [bags{bagids(i)};+dat(i,:)]; 
        labels(bagids(i)) = instance_labels(i);
    end
end