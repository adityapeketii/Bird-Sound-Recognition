ref_folder = 'Reference';
task_folder = 'Task';

ref_files = dir(fullfile(ref_folder, '*.wav'));
num_ref_files = length(ref_files);
ref_features = cell(num_ref_files, 1);

for k = 1:num_ref_files
    [audio_data, fs] = audioread(fullfile(ref_folder, ref_files(k).name));
    audio_data = audio_data / max(abs(audio_data));
    ref_features{k} = abs(spectrogram(audio_data, 256, 128, 256, fs));
end

task_files = dir(fullfile(task_folder, '*.wav'));
num_task_files = length(task_files);
task_results = cell(num_task_files, 1);

for i = 1:num_task_files
    [task_audio_data, task_fs] = audioread(fullfile(task_folder, task_files(i).name));
    task_audio_data = task_audio_data / max(abs(task_audio_data));
    [task_S, task_F, task_T] = spectrogram(task_audio_data, 256, 128, 256, task_fs);
    task_feature = abs(task_S);
    
    max_correl = zeros(num_ref_files, 1);
    for j = 1:num_ref_files
        min_len = min(size(task_feature, 2), size(ref_features{j}, 2));
        ref_feature = ref_features{j}(:, 1:min_len);
        task_feature_new = task_feature(:, 1:min_len);
        
        %using the correlation function
        correlation_matrix = xcorr2(ref_feature, task_feature_new);
        max_correl(j) = max(correlation_matrix(:));
        tem = max(correlation_matrix(:));
        fprintf('Bird %d correlation',j);
        disp(tem);
    end
    
    fprintf('Max correlation value out of the three');
    disp(max(max_correl));
    [~, best_match_index] = max(max_correl);
    task_results{i} = ref_files(best_match_index).name;
    
    %------------------plotting-----------------------------------------------------------------------------
    % Load the matched reference signal
    [matched_audio_data, matched_fs] = audioread(fullfile(ref_folder, ref_files(best_match_index).name));
    matched_audio_data = matched_audio_data / max(abs(matched_audio_data));
    [matched_S, matched_F, matched_T] = spectrogram(matched_audio_data, 256, 128, 256, matched_fs);

    % Plotting the spectrograms
    figure;
    subplot(2, 1, 1);
    imagesc(task_T, task_F, 20*log10(abs(task_S)));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['Task File: ', task_files(i).name]);
    colorbar;

    subplot(2, 1, 2);
    imagesc(matched_T, matched_F, 20*log10(abs(matched_S)));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['Matched Reference File: ', ref_files(best_match_index).name]);
    colorbar;

    % Displaying frequency peaks for the task file
    avg_task_spectrum = mean(task_feature, 2);
    [task_pks, task_locs] = findpeaks(avg_task_spectrum, task_F, 'MinPeakProminence', 0.1);
    fprintf('Frequency peaks for %s: %s Hz\n', task_files(i).name, num2str(task_locs', '%.2f '));

    % Displaying frequency peaks for the matched reference file
    avg_matched_spectrum = mean(abs(matched_S), 2);
    [matched_pks, matched_locs] = findpeaks(avg_matched_spectrum, matched_F, 'MinPeakProminence', 0.1);
    fprintf('Frequency peaks for matched reference %s: %s Hz\n\n', ref_files(best_match_index).name, num2str(matched_locs', '%.2f '));
end

for k = 1:num_task_files
    fprintf('The bird sound in %s file is the sound of %s\n', task_files(k).name, task_results{k});
end
