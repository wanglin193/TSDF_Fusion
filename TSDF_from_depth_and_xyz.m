function [SDF,Wt] = TSDF_from_depth_and_xyz(dp,pose,x,y,z,Kdp,Th_trunc,range)
%   Truncated distance volume of a depth image
%   [SDF,Wt] = TSDF_from_depth_and_xyz(dp,pose,x,y,z,Kdp,Th_trunc,range)
%  by Wang Lin
%  2019.7.28
 
dp(dp<range(1) | dp>range(2)) = 1e9; 
% SDF weight
vol_res = size(x);
Wt = ones(vol_res(1),vol_res(2),vol_res(3),'uint8');

% [R|T] * [x;y;z], volume to camera space              
p3x = single(pose(1,1)*x + pose(1,2)*y + pose(1,3)*z + pose(1,4));
p3y = single(pose(2,1)*x + pose(2,2)*y + pose(2,3)*z + pose(2,4));
p3z = single(pose(3,1)*x + pose(3,2)*y + pose(3,3)*z + pose(3,4));

% p2d = K*P3d, project points onto depth map.
p2dx = Kdp(1,1)*(p3x./p3z) + Kdp(1,3);
p2dy = Kdp(2,2)*(p3y./p3z) + Kdp(2,3);

% sdf = v2d - z
v2d_depth = interp2( dp, p2dx, p2dy, 'nearest', 1e9 ); %Ô½½çÖÃNaN
SDF = single( v2d_depth - p3z );

% Truancated SDF 
msk = SDF>Th_trunc | SDF<-Th_trunc;
SDF(msk) = NaN;
Wt(msk) = 0; 
SDF = SDF/Th_trunc; 
return
 