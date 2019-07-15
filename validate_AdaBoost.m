% generate a simple 2D two-class problem dataset, store the labels 
dataset = gendats();
labels = getlab(dataset) - 1;

% initialize AdaBoost parameters
T = 100;
dataset = +dataset;
dataset(:,3) = labels;
WeakLearn = @weighted_decision_stump_train;
N = size(dataset,1);
D = ones(N,1)/N;
[~,~,~,~,~,~,w] = AdaBoost_training(dataset,D,WeakLearn,T);

% get the largest weights of the final weak learner and display them on the
% original data
for i=1:T
    weights = w(i,:);
    largest_weight = max(weights);
    largest_weight_objects = find(weights==largest_weight);
    scatterd(prdataset(dataset(:,1:2),dataset(:,3)))
    title(strjoin({'Simple','Problem','Iteration',num2str(i)},' '))
    hold on
    scatter(dataset(largest_weight_objects,1),dataset(largest_weight_objects,2))
    saveas(gcf,strjoin({'fsiter',num2str(i),'.png'},''),'png')
    clf
end

% generate a 2D two-class banana dataset, store its labels and visualize it
dataset2 = gendatb(); 
labels2 = nan(100,1);
for i=1:50
    labels2(i) = 0;
end
for i=51:100
    labels2(i) = 1;
end
figure


% train AdaBoost on the dataset
dataset2 = +dataset2;
dataset2(:,3) = labels2;
[~,~,~,~,~,~,w2] = AdaBoost_training(dataset2,D,WeakLearn,T);

% visualize the largest weights of the final weak learner
for i=1:T
    weights = w2(i,:);
    largest_weight = max(weights);
    largest_weight_objects = find(weights==largest_weight);
    scatterd(prdataset(dataset2(:,1:2),dataset2(:,3)))
    title(strjoin({'Banana','Problem','Iteration',num2str(i)},' '))
    hold on
    scatter(dataset2(largest_weight_objects,1),dataset2(largest_weight_objects,2))
    saveas(gcf,strjoin({'fbiter',num2str(i),'.png'},''),'png')
    clf
end

% generate a 2D two-class difficult problem, store its labels and visualize
% it
dataset3 = gendatd(); 
labels3 = nan(100,1);
for i=1:50
    labels3(i) = 0;
end
for i=51:100
    labels3(i) = 1;
end


% train AdaBoost on the dataset and visualize the objects with the largest
% weights for the final weak learner
dataset3 = +dataset3;
dataset3(:,3) = labels3;
[~,~,~,~,~,~,w3] = AdaBoost_training(dataset3,D,WeakLearn,T);

for i=1:T
    weights = w3(i,:);
    largest_weight = max(weights);
    largest_weight_objects = find(weights==largest_weight);
    scatterd(prdataset(dataset3(:,1:2),dataset3(:,3)))
    title(strjoin({'Difficult','Problem','Iteration',num2str(i)},' '))
    hold on
    scatter(dataset3(largest_weight_objects,1),dataset3(largest_weight_objects,2))
    saveas(gcf,strjoin({'fditer',num2str(i),'.png'},''),'png')
    clf
end