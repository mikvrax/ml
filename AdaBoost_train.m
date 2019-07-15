function [features,thresholds,y,b,criterion,hf,w] = AdaBoost_train(dataset,D,WeakLearn,T)
    % compute the number of objects and features in the dataset and the 
    % object labels
    N = size(dataset,1);
    N_features = size(dataset,2);
    labels = dataset(:,N_features); 
    dataset = dataset(:,1:N_features-1);
    
    % initialize the arrays that will store object weights, the normalized 
    % object weights, the object class hypotheses of each weak learner, the
    % exponents of b, the final hypotheses, the coefficient of each weak
    % learner, the error of each weak learner, the optimal feature,
    % threshold and sign of the decision rule of each weak learner and the
    % value of the criterion for the final classification
    w = nan(T,N);
    w(1,:) = D;
    p = nan(T,N);
    h = nan(T,N);
    exponent = nan(N,1);
    criterion = 0;
    hf = nan(N,1);
    b = nan(T,1);
    e = nan(T,1);
    features = nan(T,1);
    thresholds = nan(T,1);
    y = nan(T,1);
    
    % repeat for each weak learner
    for t=1:T
        % normalize object weights
        p(t,:) = w(t,:)/sum(w(t,:));
        % train current weak learner using the custom weights
        [features(t),thresholds(t),y(t),h(t,:)] = WeakLearn(dataset,labels,p(t,:));
        % compute the error of the current weak learner
        e(t) = 0;
        for i=1:N
            e(t) = e(t) + p(t,i)*(abs(h(t,i) - labels(i)));
        end
        % compute the coefficient of the current weak learner
        b(t) = e(t)/(1 - e(t));
        % compute the exponent of the coefficient for each object, so that
        % each wrongly classified object has 0 and each correctly
        % classified object 1
        for i=1:N
            exponent(i) = 1 - abs(h(t,i) - labels(i));
        end
        % compute b to the power of the expoennt for each object
        temp = power(b(t),exponent);
        % update weights 
        for i=1:N
            w(t+1,i) = w(t,i) * temp(i);
        end
        % update criterion value
        criterion = criterion + log(1/b(t));
    end
    % compute the final criterion value
    criterion = 1/2 * criterion;
    % compute the combined hypothesis for each object and decide on the
    % final class hypothesis based on a comparision with the criterion 
    % value
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