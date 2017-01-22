close all; clear all;
%%%%%%%%%%%set up current %%%%%%%%%%%%%%

output_stem='dc_array_circle32';

[cx,cy,cz]=textread('array_circle32.txt','%f %f %f');

V=[cx(1:2:end) cy(1:2:end) cz(1:2:end)]./1;
N=V-[cx(2:2:end) cy(2:2:end) cz(2:2:end)]./1;

circle_radius=ones(32,1).*10;
circle_radius=ones(size(circle_radius)).*40;

ports=32;

div=16;
    
T=zeros(4,4);
for p=1:ports
    phi=atan(sqrt(N(p,1)^2+N(p,2)^2)/N(p,3));
    the=atan2(N(p,1),N(p,2));
    
    t_x=[1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
    t_z=[cos(the) sin(the) 0;-sin(the) cos(the) 0;0 0 1];
    
    T(4,:)=[0 0 0 1];
    T(1:3,4)=V(p,:)';
    T(1:3,1:3)=t_z*t_x;
    
    for d=1:div
        circle{d}.start=[cos(2*pi/div*d), sin(2*pi/div*d), 0].*circle_radius(p);
        circle{d}.stop=[cos(2*pi/div*(d+1)), sin(2*pi/div*(d+1)), 0].*circle_radius(p);
    end;

    for d=1:div
        cc1=T*[circle{d}.start 1]';
        current{p,d}.start=cc1(1:3)';
        cc2=T*[circle{d}.stop 1]';        
        current{p,d}.stop=cc2(1:3)';
    end;
end;

[vertices, faces, vertex_os, face_os]=inverse_read_surf_asc('../bem_watershed/lh.lf_outer_skin_surface.asc');

vertex_os=vertex_os(1:3,:)';
face_os=face_os(1:3,:)';

vertex_os(:,2)=vertex_os(:,2).*-1;

phi=0./180*pi;
the=0./180*pi;
t_x=[1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
t_z=[cos(the) sin(the) 0;-sin(the) cos(the) 0;0 0 1];

vertex_os=vertex_os*t_x'*t_z';


brain_x=max(vertex_os(:,1))-min(vertex_os(:,1));
brain_y=max(vertex_os(:,2))-min(vertex_os(:,2));
brain_z=max(vertex_os(:,3))-min(vertex_os(:,3));

coil_x=max(V(:,1))-min(V(:,1));
coil_y=max(V(:,2))-min(V(:,2));
coil_z=max(V(:,3))-min(V(:,3));

vertex_os=vertex_os.*0.93;

vertex_os(:,1)=vertex_os(:,1)-4.5;
vertex_os(:,2)=vertex_os(:,2)-3;
vertex_os(:,3)=vertex_os(:,3)+(max(V(:,3))-max(vertex_os(:,3)))-20;

%tri=delaunay3(vertex_os(:,1),vertex_os(:,2),vertex_os(:,3));
tri=delaunay(vertex_os(:,1),vertex_os(:,2),vertex_os(:,3));

face=face_os+1;
vertex=vertex_os;
data=ones(size(vertex,1),1);

p_os=patch('Faces',face,...
    'Vertices',vertex,...
    'MarkerEdgeColor','none',...
    'EdgeColor','none',...
    'FaceColor',[1 0.75 0.65],...
    'FaceAlpha','flat',...
    'FaceVertexAlphaData',1.0,...
    'FaceLighting', 'flat',...
    'SpecularStrength' ,0.7, 'AmbientStrength', 0.7,...
    'DiffuseStrength', 0.1, 'SpecularExponent', 10.0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lightangle(45,30); 
lightangle(135,30); 
lightangle(225,30); 
lightangle(315,30); 
lightangle(90,-30); 
lightangle(270,-30); 

lighting phong;

%set(gcf,'Renderer','zbuffer'); 

axis off equal vis3d;

hold on;

for p=1:ports
    for d=1:div
        h=line([current{p,d}.start(1);current{p,d}.stop(1)],[current{p,d}.start(2);current{p,d}.stop(2)],[current{p,d}.start(3);current{p,d}.stop(3)]);
        set(h,'color',[0.3 0.3 0.3]);
        set(h,'linewidth',1);
    end;
%    keyboard;
end;

grid on;
view(30,15);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    setup FOV for B1 calclation                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('CREATING FOV...\n');

dim_y_start=-150;
dim_y_stop=150;
dim_y_mat=64;
dim_y_skip=(dim_y_stop-dim_y_start)./(dim_y_mat-1);
dim_y=[dim_y_start:dim_y_skip:dim_y_stop];

dim_x_start=-150; 
dim_x_stop=150;
dim_x_mat=64;
dim_x_skip=(dim_x_stop-dim_x_start)./(dim_x_mat-1);
dim_x=[dim_x_start:dim_x_skip:dim_x_stop];


dim_z_start=-150;
dim_z_stop=150;
dim_z_mat=64;
dim_z_skip=(dim_z_stop-dim_z_start)./(dim_z_mat-1);
dim_z=[dim_z_start:dim_z_skip:dim_z_stop];

[fov_y,fov_x,fov_z]=ndgrid(dim_y,dim_x,dim_z);

fov_grid=[fov_x(1:prod(size(fov_x)))', fov_y(1:prod(size(fov_y)))', fov_z(1:prod(size(fov_z)))'];

%intesect FOV with brain mesh
[k,d]=dsearchn(vertex_os,tri,fov_grid);
v=zeros(size(k));
v(find(d<10))=1;
vv=reshape(v,[length(dim_y),length(dim_x),length(dim_z)]);
for s=1:size(vv,3)
	mask(:,:,s)=imfill(im2bw(vv(:,:,s)),'holes');
end;
mask=double(mask);
%slice(fov_x,fov_y,fov_z,vv,[],[],30); %z=0 plane
%axis tight equal;

%%%%%%%%%%% Biot-Savart's law %%%%%%%%%%%%%%
fprintf('CALCULATING B1...\n');
clear cc;
for p=1:size(current,1)
    fprintf('port [%d]...\n',p);
    for x=1:size(current,2)
        cc{x}=current{p,x};
    end;
    b1=b1sim_dc_core(cc,fov_grid);

    b1_abs(:,:,:,p)=squeeze(sqrt(sum(b1.^2,2)));
    b1_x(:,:,:,p)=reshape(b1(:,1),[length(dim_y),length(dim_x),length(dim_z)]);
    b1_y(:,:,:,p)=reshape(b1(:,2),[length(dim_y),length(dim_x),length(dim_z)]);
    b1_z(:,:,:,p)=reshape(b1(:,3),[length(dim_y),length(dim_x),length(dim_z)]);
    b1_effect(:,:,:,p)=b1_x(:,:,:,p)+sqrt(-1.0).*b1_y(:,:,:,p);
end;

b1_effect_total=squeeze(sqrt(mean(abs(b1_effect).^2,4)));

%%%%%%%%%%% formating b1 %%%%%%%%%%%%%%
figure;
slice(fov_x,fov_y,fov_z,etc_threshold(b1_effect_total,0.999),[],[],0); %z=0 plane
colormap(gray);

hold on;
for p=1:ports
    for d=1:div
        h=line([current{p,d}.start(1);current{p,d}.stop(1)],[current{p,d}.start(2);current{p,d}.stop(2)],[current{p,d}.start(3);current{p,d}.stop(3)]);
        set(h,'color',[0 0 1]);
        set(h,'linewidth',1);
    end;
end;
hold off;
axis equal;



%%%%%%%%%%% save data %%%%%%%%%%%%%%
save b1sim_dc_array_circle32_full.mat b1_x b1_y b1_z mask
save b1sim_dc_array_circle32.mat b1_effect