function [label] = combineinstlabels(labels,N_classes)
    % create a vector that will store the votes
    voting = zeros(N_classes,1);
    %label = 1;
    
    % compute the total votes for each label
    for i=1:size(labels,1)
        voting(labels(i)) = voting(labels(i)) + 1;
    %   label = label*labels(i); 
    end
    %label = median(labels);
    % get the majority vote
    [~,label] = max(voting);
    %label = max(labels);
end
