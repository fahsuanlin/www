close all; clear all;


%an example of showing STC on the inflated left hemisphere cortex
[stc,v_lh]=inverse_read_stc('average_fsaverage_kini_visual_02_inv_s_dspm-lh.stc');
etc_render_fsbrain('overlay_stc',stc,'overlay_vertex',v_lh,'overlay_threshold',[4 6]);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a few more examples

%simple examples of showing cortex geometry and overlay

%example 1: showing default brain (subject: "fsaverage"; left hemisphere
%inflated brain surface in the medial view)
etc_render_fsbrain();

%example 2: showing default brain without differentiating gray/white matter
%in different gray/white colors
etc_render_fsbrain('flag_curv',0);

%example 3: showing default brain without differentiating gray/white matter
%in different gray/white colors on the pial surface
etc_render_fsbrain('flag_curv',0,'surf','pial');

%example 4: showing default brain (subject: "fsaverage"; left hemisphere
%pial brain surface in the medial view)
etc_render_fsbrain('surf','pial');

%example 5: showing functional overlay (defined by a STC file) on the default brain (subject: "fsaverage"; left hemisphere
%inflated brain surface in the medial view)
threshold_fs=[0.5 0.8];
[sensitivity_lh,v_lh]=inverse_read_stc('render_example_overlay-lh.stc');
etc_render_fsbrain('overlay_value',sensitivity_lh(:,1),'overlay_vertex',v_lh,'overlay_threshold',threshold_fs);

%example 6: showing functional overlay (defined by a STC file) on the default brain (subject: "fsaverage"; left hemisphere
%pial brain surface in the medial view)
etc_render_fsbrain('overlay_value',sensitivity_lh(:,1),'overlay_vertex',v_lh,'overlay_threshold',threshold_fs,'surf','pial');



