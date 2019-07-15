function [hf] = AdaBoost_test(dataset,WeakLearn,T,features,thresholds,y,b,criterion)
    % compute the number of objects and features in the dataset, the
    % object class labels
    N = size(dataset,1);
    N_features = size(dataset,2);
    labels = dataset(:,N_features); 
    dataset = dataset(:,1:N_features-1);
    % initialize the object class hypotheses array for all weak learners
    % and the final hypotheses array
    h = nan(T,N);
    hf = nan(N,1);
    
    % compute the hypotheses of each weak learner based on the optimal
    % parameters found during training
    for t=1:T
        h(t,:) = WeakLearn(features(t),thresholds(t),y(t),dataset,labels);
    end
    % compute the combined hypothesis for each object and decide on its 
    % based on the criterion 
    for i=1:N
        accumulator = 0;
        for t=1:T
            accumulator = accumulator + log(1/b(t))*h(t,i);
        end
        if accumulator >= criterion
            hf(i) = 1;
        else
            hf(i) = 0;
        end
    end
end