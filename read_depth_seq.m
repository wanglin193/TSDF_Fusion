function [ depth_seq ] = read_depth_seq( depth_name )

fid = fopen(depth_name, 'r'); 
%% get w,h,fnum
c = fread(fid,3,'int32');
 
fseek(fid,0,'eof');
len = ftell(fid);
fnum = ( len - 3*4 )/( c(1) * c(2) * 2 );

%% read again
frewind(fid)
%[w,h,0]
c = fread(fid,3,'int32');
%figure(1)
depth_seq=[];
for i = 1:fnum           
    depth = fread(fid,[c(1),c(2)],'ushort')';
    if(isempty(depth))
        break;
    end
   % figure(1),imshow(depth,[])    
    depth_seq = cat(3,depth_seq,depth);
end
 
fclose(fid);
 
end

