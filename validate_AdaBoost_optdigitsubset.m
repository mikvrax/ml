% read digits dataset, create labels
dataset = dlmread('optdigitsubset.txt');
labels = nan(size(dataset,1),1);
for i=1:554
    labels(i) = 0;
end
for i=555:1125
    labels(i) = 1;
end

% create object and labels training and test sets
T = 200;
training = [dataset(1:50,:) ; dataset(555:604,:)];
labels_training = [labels(1:50,:) ; labels(555:604,:)];
training(:,size(training,2)+1) = labels_training;
test = [dataset(51:554,:) ; dataset(605:1125,:)];
labels_test = [labels(51:554,:) ; labels(605:1125,:)];
test(:,size(test,2)+1) = labels_test;
errors = zeros(T,1);
N_train = size(training,1);
N_test = size(test,1);

% initialize AdaBoost parameters
WeakLearnTrain = @weighted_decision_stump_train;
WeakLearnTest = @decision_stump_test;
D = ones(N_train,1)/N_train;

% repeat the training and testing procedure for an inceremental number of 
% weak learners
for i=1:T
    [features,thresholds,y,b,criteria,~,w] = AdaBoost_train(training,D,WeakLearnTrain,i);
    
    hf = AdaBoost_test(test,WeakLearnTest,i,features,thresholds,y,b,criteria);
    for j=1:N_test
        if hf(j) ~= labels_test(j)
            errors(i) = errors(i) + 1;
        end
    end
    errors(i) = errors(i)/N_test;    
end

% plot the true classification error
plot(errors)
title('Adaboost Classification Error')
xlabel('Number of weak classifiers')
ylabel('Error')

% get the training objects with the highest weight for the best classifier
% and display them
[~,best_classifier] = min(errors);
[~,~,~,~,~,~,w] = AdaBoost_train(training,D,WeakLearnTrain,best_classifier);
largest_weight = max(w(best_classifier+1,:));
largest_weight_objects = find(w(best_classifier+1,:)==largest_weight);
for j=1:size(largest_weight_objects,1)
    figure
    imshow(reshape(training(largest_weight_objects(j),1:64),8,8));
end