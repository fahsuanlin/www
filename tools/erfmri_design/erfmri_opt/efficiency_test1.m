close all; clear all;
%------------------------------------------------------------------------------------
hdr_length=30.0; %second
hdr_pre=6.0; 	%second (pre-stim)
TR=2; %second
flag_hdr_canonical=1;
flag_hdr_fir=0;

design.duration=240;    %the duration of the experiment design second
design.min_isi=1;       %the minimum ISI of the design in second
design.n_trial=64;
design.t_step=1;
design.TR=2;
design.exclude_time=[];
design.exclude_condition=[0];
design.rv=[1];
design.cvec=[1];
design.param=[];

flag_display=0;
n_iterations=100;
flag_save_txt=0;
flag_save_mat=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% specify HRF
hdr_timeVec=[0:TR:hdr_length-TR]-hdr_pre;
n_hdr=round(hdr_length/TR);
hdr_baseline_idx=find(hdr_timeVec<0);
hdr_baseline_idx=[];

if(flag_hdr_canonical)
    hhdr_timeVec=hdr_timeVec;
    hhdr_timeVec(find(hhdr_timeVec<0))=0;
    HDR=fmri_hdr(hhdr_timeVec);
    %HDR=HDR(:,1);
elseif(flag_hdr_fir)
    HDR=eye(n_hdr);
end;

hrf.timeVec=hdr_timeVec;
hrf.duration=hdr_length;
hrf.pre=hdr_pre;
hrf.hrf=HDR;


%%%%%%%%%%%%%%%%%%%%% specify design parameters

efficiency_opt=-inf;
efficiency_wst=inf;
for i=1:n_iterations;
    [efficiency(i),param]=fmri_design_efficiency(design, hrf, 'flag_display',flag_display);
    if(efficiency(i)>efficiency_opt)
        param_opt=param;
        efficiency_opt=efficiency(i);
    end;
    if(efficiency(i)<efficiency_wst)
        param_worst=param;
        efficiency_wst=efficiency(i);
    end;
    
    efficiency_optimal(i)=efficiency_opt;
    efficiency_worst(i)=efficiency_wst;

    if(mod(i,10)==0)
        hold on; semilogx(efficiency_optimal,'r');
        hold on; semilogx(efficiency_worst,'k');
        set(gca,'xscale','log');
        xlabel('iteration'); ylabel('efficiency');
        pause(0.1);
    end;

end;

fprintf('optimal efficiency: %2.2f\n',efficiency_optimal(end));
fprintf('worst efficiency: %2.2f\n',efficiency_worst(end));
fprintf('optimal/worst efficiency gain: %2.2f\n',efficiency_optimal(end)./efficiency_worst(end));
fprintf('optimal/init. efficiency gain: %2.2f\n',efficiency_optimal(end)./efficiency(1));

if(flag_save_txt)
    fn=sprintf('ex1-opt_param_%s.txt',date);
    fprintf('saving [%s]...\n',fn);
    fp=fopen(fn,'w');
    fprintf(fp,'%d\n',param_opt);
    fclose(fp);
end;

if(flag_save_mat)
    fn=sprintf('ex1-opt_param_%s.mat',date);
    fprintf('saving [%s]...\n',fn);
    save(fn,'param_opt','design','hrf','efficiency_optimal');
end;

return;

