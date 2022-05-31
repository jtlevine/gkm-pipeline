# gkm-pipeline
A pipeline for discovery of likely CRE transcription factor elements from epigenomic sequencing data using the [LS-GKM](https://github.com/Dongwon-Lee/lsgkm) algorithm and built with [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html).

### Setup
First to set up the [Conda](https://docs.conda.io/en/latest/) environment, run the following in the project root directory:
```bash
$ conda env create -f environment.yml
$ conda activate gkmqc
```

### Running the pipeline
In its most simple form, the pipeline can be run with the following command:
```bash
$ snakemake -c[cores]
```
This will run the entire pipeline, utilizing the number of Snakemake [cores](https://snakemake.readthedocs.io/en/stable/tutorial/advanced.html?highlight=cores#step-1-specifying-the-number-of-used-threads) specified to do so. However, before actually running an operation, it us reccommended to first perform a [dry run](https://snakemake.readthedocs.io/en/stable/tutorial/basics.html?highlight=dry-run#step-1-mapping-reads) of the operation like so:
```bash
$ snakemake -np
```
Where the `-n` command signals a dry run. A dry run shows what operations _would_ be performed if the command was run normally, without actually running them. The `-p` command prints the actual shell commands that would be run (which can be useful to check).

To run a specifc rule (and all prior rules whose output is required to run that rule), you can specify it like so
```bash
# Dry run
$ snakemake -np [rule name]
# Real run
$ snakemake -c[cores] [rule name]
```

### Pipeline steps
The pipeline currently consists of two major steps (for now, until more are added). These two steps both appear at the top of the `Snakemake` file as [target rules](https://snakemake.readthedocs.io/en/stable/tutorial/basics.html#step-7-adding-a-target-rule), making it convenient to run them alone. They are as follows:

- `all`: Runs all steps in the pipeline (for which output doesn't already exist) from start to finish. Outputs the following files to the `results` directory:
  - `[sample].[word_length]mers.expr_enriched_tfs.txt`: Contains all transcription factors found to be significantly upregulated for the sample data
  - `[sample].[word_length]mers.TF_class_enrichment_test.txt`: (Optional) Contains information about which TF classes are upregulated for the sample data
  - `[sample].[word_length]mers.TF_family_enrichment_test.txt`: (Optional) Contains information about which TF families are upregulated for the sample data
- `generate_motif_database`: Runs only the steps needed to create the transcription factor sequence motif data file for the given transcription factor database. Outputs a file to the `data/tf_database` directory named `[tf_database_file].[word_length]_[min_word_length]mers.fimo.txt`. Note that output of this rule is required to run the main `all` rule, however this is the longest running portion of the pipeline, so there may be situations in which one wants to run this rule separately. There are also precompiled TF sequence motif data files in the `data/tf_database` directory, which may be used to automatically skip this step when running the `all` rule.

### Configuration
Configuration of the pipeline and inputs/outputs is done by changing values in the `config/config.yaml` file. The available configuration variables are as follows:
- `sample`: The name of the sample to be interrogated. The pipeline expects two files to exist in the `data/samples` directory: `[sample].tr.fa` and `[sample].neg.tr.fa`. (_Note_: this will change when initial data ingestion step is added). Default: `wgEncodeSydhTfbsGm12878Nfe2hStdAlnRep0` (which points to an example sample file)
- `word_length`: The k-mer word length to use to train the LS-GKM algorithm. Default: 11
- `min_word_length`: When compiling the TF sequence motif data file, motif sequences in the database longer than `word_length` will need to be examined as smaller subsequences. `min_word_length` defines a value (_less than_ `word_length`) which is the minimum word length to consider for this process. Reccomended value: `word_length` - 2
- `tf_database_file`: Name of the motif database file present in `data/tf_database` as `[tf_database_file].txt`. This file should be in [MEME format](https://meme-suite.org/meme/doc/meme-format.html?man_type=web). Default: `JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme` (pre-provided JASPAR 2022 database of all vertebrate transcription factors, without redundancy) 
- `tf_metadata_file`: (Optional) Name of the file containing transcription factor family and class information. Should be a 3 column tsv file without headers in the format `Motif_ID TF_family TF_class`. Default: `TF_fam` (pre-provided file of families and classes for motifs found in `JASPAR2022_CORE_vertebrates_non-redundant_pfms_meme.txt`)
- `enrichment_cutoffs`: Statistical cutoff values for determining whether a transcription factor is found to be significantly enriched for this sample. A TF is only considered significant if it passes _all three_ tests. Contains three values:
  - `percent_kmer_5p`: Minimum percentage of k-mers for a TF which must be in the top 5th percentile of SVM weight as determined by LS-GKM in ordered to be considered significant. Default: `0.1`
  - `padj_cutoff_poisson`: Adjusted p-value cutoff for the Poisson test, which uses a Poisson distribution to determine whether the number of k-mers at the top 5th percentile of SVM weight is significantly higher than average. Default: `0.01`
  - `padj_cutoff_wilcox`: Adjusted p-value cutoff for the Wilcox test, which uses a Wilcoxon rank-sum test to determine whether the average SVM weight of the k-mers associated with a TF is significantly higher than the overall average SVM weight. Default: `0.01`
