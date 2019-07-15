function [segment_features] = extractinstances(im,width)
    % perform mean shift clustering using a kernel of specific width on the
    % image
    segments = im_meanshift(im,width);

    % initialize the necessary data structures for the desired features
    N_segments = size(unique(segments),1);
    red_mean = zeros(N_segments,1);
    blue_mean = zeros(N_segments,1);
    green_mean = zeros(N_segments,1);
    segments_population = zeros(N_segments,1);
    [N_rows, N_columns] = size(segments);

    % iterate over the pixels and store RGB values according the segment
    % they are in
    for i=1:N_rows
        for j=1:N_columns
            red_mean(segments(i,j)) = red_mean(segments(i,j)) + double(im(i,j,1));
            blue_mean(segments(i,j)) = blue_mean(segments(i,j)) + double(im(i,j,2));
            green_mean(segments(i,j)) = green_mean(segments(i,j)) + double(im(i,j,3));
            segments_population(segments(i,j)) = segments_population(segments(i,j)) + 1;
        end
    end

    % compute the average RGB values of each segment
    for i=1:N_segments
       red_mean(i) = red_mean(i)/segments_population(i);
       green_mean(i) = green_mean(i)/segments_population(i);
       blue_mean(i) = blue_mean(i)/segments_population(i);
    end
    segment_features = [red_mean,green_mean,blue_mean];
end
