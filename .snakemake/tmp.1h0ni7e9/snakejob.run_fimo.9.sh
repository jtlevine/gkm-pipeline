#!/bin/sh
# properties = {"type": "single", "rule": "run_fimo", "local": false, "input": ["data/9mers.fa", "temp/JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme.5.txt"], "output": ["temp/JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme.9mers.5.fimo.txt"], "wildcards": {"tf_database_file": "JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme", "word_length": "9", "i": "5"}, "params": {}, "log": [], "threads": 1, "resources": {"mem_mb": 1000, "disk_mb": 1000, "tmpdir": "/tmp"}, "jobid": 9, "cluster": {}}
cd '/gpfs/scratch/jtl334/thesis/pipeline' && /gpfs/home/jtl334/.conda/envs/pipeline/bin/python3.7 -m snakemake --snakefile '/gpfs/scratch/jtl334/thesis/pipeline/workflow/Snakefile' 'temp/JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme.9mers.5.fimo.txt' --allowed-rules 'run_fimo' --cores 'all' --attempt 1 --force-use-threads  --wait-for-files '/gpfs/scratch/jtl334/thesis/pipeline/.snakemake/tmp.1h0ni7e9' 'data/9mers.fa' 'temp/JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme.5.txt' --force --keep-target-files --keep-remote --max-inventory-time 0 --nocolor --notemp --no-hooks --nolock --ignore-incomplete --skip-script-cleanup  --conda-frontend 'mamba' --wrapper-prefix 'https://github.com/snakemake/snakemake-wrappers/raw/' --latency-wait 5 --scheduler 'ilp' --scheduler-solver-path '/gpfs/home/jtl334/.conda/envs/pipeline/bin' --default-resources 'mem_mb=max(2*input.size_mb, 1000)' 'disk_mb=max(2*input.size_mb, 1000)' 'tmpdir=system_tmpdir' --mode 2 && touch '/gpfs/scratch/jtl334/thesis/pipeline/.snakemake/tmp.1h0ni7e9/9.jobfinished' || (touch '/gpfs/scratch/jtl334/thesis/pipeline/.snakemake/tmp.1h0ni7e9/9.jobfailed'; exit 1)

