


function out = cartoon(im)

    k_centers = 10;

    h = length(im(:,1,1));
    w = length(im(1,:,1));
               
               
    kmeans_data = zeros(3, h*w);

    [row, col] = find(ones(h,w));
    
    for i = 1:length(row)
        kmeans_data(:,i) = im(row(i),col(i),:);
    end

    [C, A, E] = vl_kmeans(kmeans_data, k_centers);

    im_seg = zeros(h, w, 3);

    for i = 1:length(row)

        im_seg(row(i), col(i), :) = (C(:,A(i)))/255;

    end

    
    %Median filtering
    for rgb = 1:3
       im_seg(:,:,rgb) = medfilt2(im_seg(:,:,rgb), [5 5]); 
    end
    
    
    edges = canny(im, 4, 1.4, 0.1);
    edge_shade = .1;
    
    dilation = 0;  
    edges = bwdist(edges) <= dilation;
        
    complement = 1 - edges;
    
    for rgb = 1:3
        out(:,:,rgb) = im_seg(:,:,rgb) .* complement;
        out(:,:,rgb) = out(:,:,rgb) + edges * edge_shade;
    end
    
    figure(1)
    imshow(out);
    
end