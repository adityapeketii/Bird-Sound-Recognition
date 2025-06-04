ref_folder = 'Reference';
task_folder = 'Task';

ref_files = dir(fullfile(ref_folder, '*.wav'));
num_ref_files = length(ref_files);
ref_features = cell(num_ref_files,1);

for k = 1:num_ref_files
    [audio_data, fs] = audioread(fullfile(ref_folder,ref_files(k).name));
    audio_data = audio_data/max(abs(audio_data));
    ref_features{k} = abs(spectrogram(audio_data, 256, 128, 256, fs));

end

task_files = dir(fullfile(task_folder, '*.wav'));
num_task_files = length(task_files);
task_results = cell(num_task_files,1);

for i = 1:num_task_files
    [task_audio_data, task_fs] = audioread(fullfile(task_folder, task_files(i).name));
    task_audio_data = task_audio_data/max(abs(task_audio_data));
    task_feature = abs(spectrogram(task_audio_data, 256, 128, 256, task_fs));


    max_correl = zeros(num_ref_files, 1);
    for j = 1:num_ref_files
        min_len = min(size(task_feature, 2), size(ref_features{j}, 2));
        ref_feature = ref_features{j}(:, 1:min_len);
        task_feature_new = task_feature(:, 1:min_len);

        correlation_matrix = xcorr2(ref_feature,task_feature_new);
        max_correl(j) = max(correlation_matrix(:));
        temp = max(correlation_matrix(:));
        fprintf('%d ka corellatiom',j);
        disp(temp);
    end
    disp(max(max_correl));
    [~, best_match_index] = max(max_correl);
    task_results{i} = ref_files(best_match_index).name;
    disp(task_results);
end

for k = 1:num_task_files
    fprintf('The bird sound in %s file is the sound of %s\n', task_files(k).name, task_results{k});
end
