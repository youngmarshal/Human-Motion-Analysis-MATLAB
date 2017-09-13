function  [AngVel, AngAcc] = Ang2LocalAngular( theta, seq, smprate )
% Derive the angular velocity and angular acceleration from Euler angles.

% theta: Euler angles [nframes x 3]
% seq: rotation sequence of the Euler angles '1 x 3' (composed of 'x', 'y', 'z')
% smprate: sampling rate(Hz) [1 x 1]
% AngVel: angular velocity relative to local coordinate [nframes x 3]
% AngAcc: angular acceleration relative to local coordinate [nframes x 3]

if size(theta,2)~=3 || ndims(theta)~=2
    error('Euler angles matrix must in the form of [nframes x 3]')
end
n = size(theta,1);
% time sequence
TimeSeq = reshape(1/smprate:1/smprate:n/smprate,[],1);%nx1
% wrapped theta in radian
theRad = unwrap(theta/180*pi);%nx3
% Global Angular Velocity
GAV = permute([Derivative(TimeSeq, theRad(:,1), 1), Derivative(TimeSeq, theRad(:,2), 1), Derivative(TimeSeq, theRad(:,3), 1)], [2 3 1]);%3x1xn
GAV1 = GAV(1,1,:); GAV2 = GAV(2,1,:); GAV3 = GAV(3,1,:); 
% Global Angular Acceleration
GAA = permute([Derivative(TimeSeq, theRad(:,1), 2), Derivative(TimeSeq, theRad(:,2), 2), Derivative(TimeSeq, theRad(:,3), 2)], [2 3 1]);

theRad = permute(theRad, [3 2 1]);%1x3xn
tR1 = theRad(1,1,:); tR2 = theRad(1,2,:); tR3 = theRad(1,3,:);

z=zeros(1,1,n);
o=ones(1,1,n);
switch seq
    case 'zxy'
        R1 = [-cos(tR2).*sin(tR3)    cos(tR3)    z; ...
               sin(tR2)              z           o; ...
               cos(tR2).*cos(tR3)    sin(tR3)    z];%3x3xn
        R2 = [GAV2.*sin(tR2).*sin(tR3)-GAV3.*cos(tR2).*cos(tR3)   -GAV3.*sin(tR3)  z;...
              GAV2.*cos(tR2)                                      z                z;...
              -GAV2.*sin(tR2).*cos(tR3)-GAV3.*cos(tR2).*sin(tR3)  GAV3.*cos(tR3)   z];
    case 'yxz'
        R1 = [ cos(tR2).*sin(tR3)     cos(tR3)    z; ...
               cos(tR2).*cos(tR3)     -sin(tR3)   z; ...
               -sin(tR2)              z           o];%3x3xn
        R2 = [-GAV2.*sin(tR2).*sin(tR3)+GAV3.*cos(tR2).*cos(tR3)   -GAV3.*sin(tR3)   z;...
              -GAV2.*sin(tR2).*cos(tR3)-GAV3.*sin(tR3).*cos(tR2)   -GAV3.*cos(tR3)   z;...
              -GAV2.*cos(tR2)                                      z                 z];
    case 'xyz'
        R1 = [ cos(tR2).*cos(tR3)     sin(tR3)    z; ...
               -cos(tR2).*sin(tR3)    cos(tR3)    z; ...
               sin(tR2)               z           o];%3x3xn
        R2 = [-GAV2.*sin(tR2).*cos(tR3)-GAV3.*cos(tR2).*sin(tR3)  GAV3.*cos(tR3)    z;...
              GAV2.*sin(tR2).*sin(tR3)-GAV3.*cos(tR3).*cos(tR2)   -GAV3.*sin(tR3)   z;...
              GAV2.*cos(tR2)                                      z                 z];
    case 'zyx'       
        R1 = [ -sin(tR2)              z           o; ...
               cos(tR2).*sin(tR3)    cos(tR3)     z; ...
               cos(tR2).*cos(tR3)    -sin(tR3)    z];%3x3xn
        R2 = [-GAV2.*cos(tR2)                                      z                 z;...
              -GAV2.*sin(tR2).*sin(tR3)+GAV3.*cos(tR3).*cos(tR2)   -GAV3.*sin(tR3)   z;...
              -GAV2.*sin(tR2).*cos(tR3)-GAV3.*cos(tR2).*sin(tR3)   -GAV3.*cos(tR3)   z];
    case 'xyx'
        R1 = [ cos(tR2)              z            o; ...
               sin(tR2).*sin(tR3)    cos(tR3)     z; ...
               sin(tR2).*cos(tR3)    -sin(tR3)    z];%3x3xn
        R2 = [-GAV2.*sin(tR2)                                     z                 z;...
              GAV2.*cos(tR2).*sin(tR3)+GAV3.*cos(tR3).*sin(tR2)   -GAV3.*sin(tR3)   z;...
              -GAV3.*sin(tR2).*sin(tR3)+GAV2.*cos(tR2).*cos(tR3)  -GAV3.*cos(tR3)   z];
     case 'xzx'
        R1 = [ cos(tR2)              z            o; ...
               -sin(tR2).*cos(tR3)   sin(tR3)     z; ...
               sin(tR2).*sin(tR3)    cos(tR3)     z];%3x3xn
        R2 = [-GAV2.*sin(tR2)                                      z                z;...
              -GAV2.*cos(tR2).*cos(tR3)+GAV3.*sin(tR3).*sin(tR2)   GAV3.*cos(tR3)   z;...
              GAV3.*sin(tR2).*cos(tR3)+GAV2.*cos(tR2).*sin(tR3)   -GAV3.*sin(tR3)   z];
     case 'yzx' 
        R1 = [ sin(tR2)               z            o; ...
               cos(tR2).*cos(tR3)     sin(tR3)     z; ...
               -cos(tR2).*sin(tR3)    cos(tR3)     z];%3x3xn
        R2 = [GAV2.*cos(tR2)                                       z                 z;...
              -GAV2.*sin(tR2).*cos(tR3)-GAV3.*sin(tR3).*cos(tR2)   GAV3.*cos(tR3)    z;...
              -GAV3.*cos(tR2).*cos(tR3)+GAV2.*sin(tR2).*sin(tR3)   -GAV3.*sin(tR3)   z];
    case 'yxy'
        R1 = [ sin(tR2).*sin(tR3)    cos(tR3)    z; ...
               cos(tR2)              z           o; ...
               -sin(tR2).*cos(tR3)   sin(tR3)    z];%3x3xn
        R2 = [GAV2.*cos(tR2).*sin(tR3)+GAV3.*sin(tR2).*cos(tR3)   -GAV3.*sin(tR3)  z;...
              -GAV2.*sin(tR2)                                     z                z;...
              -GAV2.*cos(tR2).*cos(tR3)+GAV3.*sin(tR2).*sin(tR3)  GAV3.*cos(tR3)   z];
    case 'yzy'
        R1 = [ sin(tR2).*cos(tR3)    -sin(tR3)   z; ...
               cos(tR2)              z           o; ...
               sin(tR2).*sin(tR3)    cos(tR3)    z];%3x3xn
        R2 = [GAV2.*cos(tR2).*cos(tR3)-GAV3.*sin(tR2).*sin(tR3)   -GAV3.*cos(tR3)  z;...
              -GAV2.*sin(tR2)                                     z                z;...
              GAV2.*cos(tR2).*sin(tR3)+GAV3.*sin(tR2).*cos(tR3)  -GAV3.*sin(tR3)   z];
    case 'xzy'
        R1 = [ cos(tR2).*cos(tR3)    -sin(tR3)   z; ...
               -sin(tR2)             z           o; ...
               cos(tR2).*sin(tR3)    cos(tR3)    z];%3x3xn
        R2 = [-GAV2.*sin(tR2).*cos(tR3)-GAV3.*cos(tR2).*sin(tR3)   -GAV3.*cos(tR3)   z;...
              -GAV2.*cos(tR2)                                      z                 z;...
              -GAV2.*sin(tR2).*sin(tR3)+GAV3.*cos(tR2).*cos(tR3)   -GAV3.*sin(tR3)   z];
    case 'zxz'
        R1 = [ sin(tR2).*sin(tR3)     cos(tR3)    z; ...
               sin(tR2).*cos(tR3)     -sin(tR3)   z; ...
               cos(tR2)               z           o];%3x3xn
        R2 = [GAV2.*cos(tR2).*sin(tR3)+GAV3.*sin(tR2).*cos(tR3)   -GAV3.*sin(tR3)   z;...
              GAV2.*cos(tR2).*cos(tR3)-GAV3.*sin(tR3).*sin(tR2)   -GAV3.*cos(tR3)   z;...
              -GAV2.*sin(tR2)                                     z                 z];
    case 'zyz'        
        R1 = [ -sin(tR2).*cos(tR3)    sin(tR3)    z; ...
               sin(tR2).*sin(tR3)     cos(tR3)    z; ...
               cos(tR2)               z           o];%3x3xn
        R2 = [-GAV2.*cos(tR2).*cos(tR3)+GAV3.*sin(tR2).*sin(tR3)  GAV3.*cos(tR3)    z;...
              GAV2.*cos(tR2).*sin(tR3)+GAV3.*cos(tR3).*sin(tR2)   -GAV3.*sin(tR3)   z;...
              -GAV2.*sin(tR2)                                     z                 z];
end
AngVel = permute(mtimesx(R1, GAV),[3 1 2]);%3x1xn to nx3
AngAcc = permute(mtimesx(R2, GAV)+mtimesx(R1, GAA),[3 1 2]);
