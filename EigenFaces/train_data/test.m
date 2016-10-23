data = [ 2, 3, 4, 5; 1, 3, 4, 3; 4, 5, 2, 1; 3, 5, 2, 1; 6, 3, 3, 3];
mean_face = mean(data);
centered_data = data - mean_face;

[V, Lambda] = eig( centered_data * centered_data' );
% here Lambda = diag(lambda_1, lambda_2, ... lambda_n) where 
% lambda_n >= ... lambda_2 >= lambda_1

eigen_faces = centered_data' * V * Lambda^(-0.5);
eigen_faces = eigen_faces(:,[2,4]);

eigen_faces(:,1)
eigen_faces(:,2)
eigen_faces(:,3)