# training v3 aborted - try resume

## the output

```text
Flax classes are deprecated and will be removed in Diffusers v0.40.0. We recommend migrating to PyTorch classes or pinning your version of Diffusers.
Flax classes are deprecated and will be removed in Diffusers v0.40.0. We recommend migrating to PyTorch classes or pinning your version of Diffusers.
INFO 2026-08-01 15:43:28 ot_train.py:272 {'batch_size': 32,
 'checkpoint_path': None,
 'cudnn_deterministic': False,
 'dataloader_multiprocessing_context': 'spawn',
 'dataset': {'depth_output_unit': 'mm',
             'episodes': None,
             'eval_split': 0.0,
             'image_transforms': {'enable': False,
                                  'max_num_transforms': 3,
                                  'random_order': False,
                                  'tfs': {'affine': {'kwargs': {'degrees': [-5.0,
                                                                            5.0],
                                                                'translate': [0.05,
                                                                              0.05]},
                                                     'type': 'RandomAffine',
                                                     'weight': 1.0},
                                          'brightness': {'kwargs': {'brightness': [0.8,
                                                                                   1.2]},
                                                         'type': 'ColorJitter',
                                                         'weight': 1.0},
                                          'contrast': {'kwargs': {'contrast': [0.8,
                                                                               1.2]},
                                                       'type': 'ColorJitter',
                                                       'weight': 1.0},
                                          'hue': {'kwargs': {'hue': [-0.05,
                                                                     0.05]},
                                                  'type': 'ColorJitter',
                                                  'weight': 1.0},
                                          'saturation': {'kwargs': {'saturation': [0.5,
                                                                                   1.5]},
                                                         'type': 'ColorJitter',
                                                         'weight': 1.0},
                                          'sharpness': {'kwargs': {'sharpness': [0.5,
                                                                                 1.5]},
                                                        'type': 'SharpnessJitter',
                                                        'weight': 1.0}}},
             'repo_id': 'garagelab-duesseldorf/pap_green_foam_in_box',
             'return_uint8': False,
             'revision': None,
             'root': None,
             'streaming': False,
             'use_imagenet_stats': True,
             'video_backend': 'torchcodec'},
 'env': None,
 'env_eval_freq': 20000,
 'eval': {'batch_size': 1,
          'n_episodes': 50,
          'recording': False,
          'recording_private': False,
          'recording_repo_id': None,
          'use_async_envs': True},
 'eval_steps': 0,
 'job': {'detach': False,
         'image': 'huggingface/lerobot-gpu:latest',
         'tags': [],
         'target': None,
         'timeout': '2d'},
 'job_name': 'pap_green_foam_in_box',
 'log_freq': 200,
 'max_eval_samples': 0,
 'num_workers': 2,
 'optimizer': {'betas': [0.9, 0.999],
               'eps': 1e-08,
               'grad_clip_norm': 10.0,
               'lr': 1e-05,
               'type': 'adamw',
               'weight_decay': 0.0001},
 'output_dir': 'outputs/train/pap_green_foam_in_box-v3',
 'peft': None,
 'persistent_workers': True,
 'policy': {'chunk_size': 100,
            'device': 'cuda',
            'dim_feedforward': 3200,
            'dim_model': 512,
            'dropout': 0.1,
            'feedforward_activation': 'relu',
            'input_features': {},
            'kl_weight': 10.0,
            'latent_dim': 32,
            'license': None,
            'n_action_steps': 100,
            'n_decoder_layers': 1,
            'n_encoder_layers': 4,
            'n_heads': 8,
            'n_obs_steps': 1,
            'n_vae_encoder_layers': 4,
            'normalization_mapping': {'ACTION': <NormalizationMode.MEAN_STD: 'MEAN_STD'>,
                                      'STATE': <NormalizationMode.MEAN_STD: 'MEAN_STD'>,
                                      'VISUAL': <NormalizationMode.MEAN_STD: 'MEAN_STD'>},
            'optimizer_lr': 1e-05,
            'optimizer_lr_backbone': 1e-05,
            'optimizer_weight_decay': 0.0001,
            'output_features': {},
            'pre_norm': False,
            'pretrained_backbone_weights': 'ResNet18_Weights.IMAGENET1K_V1',
            'pretrained_path': None,
            'pretrained_revision': None,
            'private': None,
            'push_to_hub': True,
            'replace_final_stride_with_dilation': False,
            'repo_id': 'garagelab-duesseldorf/pap_green_foam_in_boxpolicy-v3',
            'tags': None,
            'temporal_ensemble_coeff': None,
            'type': 'act',
            'use_amp': False,
            'use_peft': False,
            'use_vae': True,
            'vision_backbone': 'resnet18'},
 'prefetch_factor': 4,
 'rename_map': {},
 'resume': False,
 'reward_model': None,
 'sample_weighting': None,
 'save_checkpoint': True,
 'save_checkpoint_to_hub': True,
 'save_freq': 1000,
 'scheduler': None,
 'seed': 1000,
 'steps': 20000,
 'tolerance_s': 0.0001,
 'use_policy_training_preset': True,
 'wandb': {'add_tags': True,
           'disable_artifact': False,
           'enable': False,
           'entity': None,
           'mode': None,
           'notes': None,
           'project': 'lerobot',
           'run_id': None}}
INFO 2026-08-01 15:43:28 ot_train.py:280 Logs will be saved locally.
INFO 2026-08-01 15:43:28 ot_train.py:298 Creating dataset
Downloading bytes:           |  0.00B            
Reconstructing (incomplete total...): |          |  0.00B /  0.00B            

Fetching 14 files: 100% 14/14 [00:00<00:00, 5860.89it/s]
Download complete: :           |  0.00B            
Download complete: :           |  0.00B            
Reconstruction complete: |          |  0.00B /  0.00B            
Downloading bytes:           |  0.00B            
Reconstructing (incomplete total...): |          |  0.00B /  0.00B            

Fetching 14 files: 100% 14/14 [00:00<00:00, 10237.14it/s]
Download complete: :           |  0.00B            
Download complete: :           |  0.00B            
Reconstruction complete: |          |  0.00B /  0.00B            
INFO 2026-08-01 15:43:29 ot_train.py:324 Creating policy
INFO 2026-08-01 15:43:30 ot_train.py:402 Creating optimizer and scheduler
INFO 2026-08-01 15:43:30 ot_train.py:434 Output dir: outputs/train/pap_green_foam_in_box-v3
INFO 2026-08-01 15:43:30 ot_train.py:441 cfg.steps=20000 (20K)
INFO 2026-08-01 15:43:30 ot_train.py:442 dataset.num_frames=71471 (71K)
INFO 2026-08-01 15:43:30 ot_train.py:443 dataset.num_episodes=52
INFO 2026-08-01 15:43:30 ot_train.py:446 Effective batch size: 32 x 1 = 32
INFO 2026-08-01 15:43:30 ot_train.py:447 num_learnable_params=51597190 (52M)
INFO 2026-08-01 15:43:30 ot_train.py:448 num_total_params=51597190 (52M)
Training:   0% 0/20000 [00:00<?, ?step/s]INFO 2026-08-01 15:43:30 ot_train.py:597 Start offline training on a fixed dataset, with effective batch size: 32
Flax classes are deprecated and will be removed in Diffusers v0.40.0. We recommend migrating to PyTorch classes or pinning your version of Diffusers.
Flax classes are deprecated and will be removed in Diffusers v0.40.0. We recommend migrating to PyTorch classes or pinning your version of Diffusers.
Flax classes are deprecated and will be removed in Diffusers v0.40.0. We recommend migrating to PyTorch classes or pinning your version of Diffusers.
Flax classes are deprecated and will be removed in Diffusers v0.40.0. We recommend migrating to PyTorch classes or pinning your version of Diffusers.
Training:   1% 200/20000 [07:01<10:34:05,  1.92s/step]INFO 2026-08-01 15:50:31 ot_train.py:641 step:200 smpl:6K ep:5 epch:0.09 loss:6.148 grdn:101.587 lr:1.0e-05 updt_s:1.963 data_s:0.144 smp/s:15 mem_gb:13.09 l1_loss:0.499 kld_loss:0.565
Training:   2% 400/20000 [13:25<10:28:08,  1.92s/step]INFO 2026-08-01 15:56:55 ot_train.py:641 step:400 smpl:13K ep:9 epch:0.18 loss:2.445 grdn:52.695 lr:1.0e-05 updt_s:1.911 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.364 kld_loss:0.208
Training:   3% 600/20000 [19:49<10:20:11,  1.92s/step]INFO 2026-08-01 16:03:19 ot_train.py:641 step:600 smpl:19K ep:14 epch:0.27 loss:1.979 grdn:45.717 lr:1.0e-05 updt_s:1.911 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.327 kld_loss:0.165
Training:   4% 800/20000 [26:13<10:14:51,  1.92s/step]INFO 2026-08-01 16:09:43 ot_train.py:641 step:800 smpl:26K ep:19 epch:0.36 loss:1.656 grdn:40.260 lr:1.0e-05 updt_s:1.911 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.300 kld_loss:0.136
Training:   5% 1000/20000 [32:37<10:10:13,  1.93s/step]INFO 2026-08-01 16:16:07 ot_train.py:641 step:1K smpl:32K ep:23 epch:0.45 loss:1.411 grdn:37.825 lr:1.0e-05 updt_s:1.912 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.288 kld_loss:0.112
INFO 2026-08-01 16:16:07 ot_train.py:687 Checkpoint policy after step 1000
Found 11 files to upload
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ░░░░░░░░░░░░░░░░░░░░  0 / 3 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  564kB · 1.12MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  13.5MB · 8.56MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  46.8MB · 25.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  79.0MB · 37.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  87.4MB · 31.3MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  102MB · 30.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  148MB · 48.6MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  199MB · 65.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  219MB · 57.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  249MB · 58.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  300MB · 71.3MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  357MB · 84.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  414MB · 93.3MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  454MB · 89.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  491MB · 84.3MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  528MB · 81.3MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  551MB · 70.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  570MB · 60.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  578MB · 47.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  592MB · 41.6MB/s
  Committing  ░░░░░░░░░░� Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 22.3MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 15.6MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 10.9MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 10.9MB/s ✓
  Committing  ████████████████████  11 / 11 ✓
Training:   6% 1200/20000 [39:28<10:02:35,  1.92s/step]INFO 2026-08-01 16:22:58 ot_train.py:641 step:1K smpl:38K ep:28 epch:0.54 loss:1.209 grdn:34.749 lr:1.0e-05 updt_s:1.914 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.274 kld_loss:0.093
Training:   7% 1400/20000 [45:51<9:51:51,  1.91s/step]INFO 2026-08-01 16:29:22 ot_train.py:641 step:1K smpl:45K ep:33 epch:0.63 loss:1.030 grdn:31.775 lr:1.0e-05 updt_s:1.910 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.261 kld_loss:0.077
Training:   8% 1600/20000 [52:15<9:48:41,  1.92s/step]INFO 2026-08-01 16:35:46 ot_train.py:641 step:2K smpl:51K ep:37 epch:0.72 loss:0.878 grdn:29.636 lr:1.0e-05 updt_s:1.912 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.249 kld_loss:0.063
Training:   9% 1800/20000 [58:39<9:43:47,  1.92s/step]INFO 2026-08-01 16:42:10 ot_train.py:641 step:2K smpl:58K ep:42 epch:0.81 loss:0.745 grdn:26.914 lr:1.0e-05 updt_s:1.912 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.232 kld_loss:0.051
Training:  10% 2000/20000 [1:05:03<9:34:08,  1.91s/step]INFO 2026-08-01 16:48:34 ot_train.py:641 step:2K smpl:64K ep:47 epch:0.90 loss:0.643 grdn:25.142 lr:1.0e-05 updt_s:1.910 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.221 kld_loss:0.042
INFO 2026-08-01 16:48:34 ot_train.py:687 Checkpoint policy after step 2000
Found 11 files to upload
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ░░░░░░░░░░░░░░░░░░░░  0 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  3.99MB · 7.95MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  50.0MB · 33.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  102MB · 54.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  133MB · 56.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  134MB · 40.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  154MB · 40.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  192MB · 50.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  232MB · 59.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  278MB · 69.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  336MB · 83.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  370MB · 79.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  418MB · 83.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  457MB · 81.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  494MB · 79.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  536MB · 81.0MB/s
  Committing  ░░░░░░░░░�s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████░░░░░░░░  3 / 5 files  582MB · 44.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  587MB · 34.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  591MB · 26.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  595MB · 21.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  600MB · 17.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  606MB · 15.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  612MB · 14.6MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  616MB · 12.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  616MB · 9.04MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 6.65MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 4.65MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 3.26MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 3.26MB/s ✓
  Committing  ████████████████████  11 / 11 ✓
Training:  11% 2200/20000 [1:11:57<9:30:47,  1.92s/step]INFO 2026-08-01 16:55:27 ot_train.py:641 step:2K smpl:70K ep:51 epch:0.99 loss:0.558 grdn:23.490 lr:1.0e-05 updt_s:1.915 data_s:0.007 smp/s:17 mem_gb:13.09 l1_loss:0.216 kld_loss:0.034
Training:  12% 2400/20000 [1:18:28<9:22:56,  1.92s/step]INFO 2026-08-01 17:01:59 ot_train.py:641 step:2K smpl:77K ep:56 epch:1.07 loss:0.482 grdn:21.659 lr:1.0e-05 updt_s:1.942 data_s:0.013 smp/s:16 mem_gb:13.07 l1_loss:0.204 kld_loss:0.028
Training:  13% 2600/20000 [1:24:52<9:15:50,  1.92s/step]INFO 2026-08-01 17:08:22 ot_train.py:641 step:3K smpl:83K ep:61 epch:1.16 loss:0.424 grdn:20.173 lr:1.0e-05 updt_s:1.909 data_s:0.007 smp/s:17 mem_gb:13.10 l1_loss:0.194 kld_loss:0.023
Training:  14% 2800/20000 [1:31:16<9:11:06,  1.92s/step]INFO 2026-08-01 17:14:46 ot_train.py:641 step:3K smpl:90K ep:65 epch:1.25 loss:0.384 grdn:19.381 lr:1.0e-05 updt_s:1.912 data_s:0.007 smp/s:17 mem_gb:13.10 l1_loss:0.189 kld_loss:0.019
Training:  15% 3000/20000 [1:37:40<9:04:13,  1.92s/step]INFO 2026-08-01 17:21:10 ot_train.py:641 step:3K smpl:96K ep:70 epch:1.34 loss:0.351 grdn:19.180 lr:1.0e-05 updt_s:1.911 data_s:0.007 smp/s:17 mem_gb:13.10 l1_loss:0.187 kld_loss:0.016
INFO 2026-08-01 17:21:10 ot_train.py:687 Checkpoint policy after step 3000
Found 11 files to upload
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  573kB · 1.15MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  23.5MB · 14.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  52.7MB · 27.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  73.8MB · 32.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  78.3MB · 25.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  91.5MB · 25.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  131MB · 40.9MB/s
  Committi�  2 / 5 files  198MB · 52.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  223MB · 51.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  257MB · 56.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  307MB · 69.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  352MB · 75.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  394MB · 78.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  438MB · 81.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  491MB · 88.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  540MB · 91.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  559MB · 75.6MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  572MB · 60.6MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  591MB · 53.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  610MB · 48.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  616MB · 38.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 27.0MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 18.9MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████████  5 / 5 files  617MB · 13.2MB/s ✓
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   █████�░░░░░░░░░░░░  2 / 5 files  97.2MB · 33.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  120MB · 36.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  157MB · 47.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  187MB · 51.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  211MB · 50.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  257MB · 62.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  321MB · 82.3MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  383MB · 94.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  422MB · 89.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  452MB · 80.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  486MB · 76.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  516MB · 72.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  527MB · 56.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  534MB · 44.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  544MB · 36.7MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  553MB · 31.2MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████████████░░░░  4 / 5 files  567MB · 30.1MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Prepa��████████████  11 / 11 ✓
  Uploading   ░░░░░░░░░░░░░░░░░░░░  0 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  3.94MB · 7.86MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  27.6MB · 19.6MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  65.9MB · 36.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  89.0MB · 39.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  107MB · 38.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  123MB · 36.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  170MB · 53.4MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  200MB · 55.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  215MB · 47.9MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  257MB · 58.6MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  321MB · 79.5MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  384MB · 93.0MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  421MB · 87.8MB/s
  Committing  ░░░░░░░░░░░░░░░░░░░░  0 / 11
  Preparing   ████████████████████  11 / 11 ✓
  Uploading   ████████░░░░░░░░░░░░  2 / 5 files  453MB · 80.5MB/s
  Committing  ░░░░░░░░░░░░░�  ████████████████████  11 / 11 ✓
Training:  25% 5025/20000 [2:43:57<8:09:26,  1.96s/step]
```


