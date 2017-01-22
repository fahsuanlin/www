close all; clear all;

%load data
load sim_8ch_data.mat


R=[4];
matrix={[128 128]};

for m_idx=1:length(matrix)

	ORIG=zeros(matrix{m_idx}(1),matrix{m_idx}(2),8);
	for i=1:8
		ORIG(:,:,i)=imresize(data(:,:,i),matrix{m_idx});
        b1_resize(:,:,i)=imresize(b1(:,:,i),matrix{m_idx});
	end;

	for r_idx=1:length(R)
		sample_vector=sense_sample_vector(matrix{m_idx}(1),R(r_idx));
		A=pmri_alias_matrix(sample_vector);

		ACC=[];
		for i=1:8
			ACC(:,:,i)=A*ORIG(:,:,i);
		end;
        
        noise=randn(size(ACC))+sqrt(-1).*randn(size(ACC));
        noise_power=sum(abs(noise(:).^2));
        signal_power=sum(abs(ACC(:).^2));
        SNR=100;
        noise=noise.*sqrt(signal_power./SNR./noise_power);
        ACC0=ACC;
        ACC=ACC+noise;

		[A,profile_est,C,PRIOR]=pmri_prep('ref',ORIG,'obs',ACC,'sample_vector',sample_vector);
		
		C=eye(8);

        [recon_unreg, g_unreg]=pmri_core('A',A,'Y',ACC,'S',b1_resize,'C',C,'flag_unreg',1,'flag_display',1,'flag_unreg_g',1);
		
		fn=sprintf('sense_8ch_example.mat');
		save(fn,'recon_unreg','g_unreg');
	end;
end;

return;
