# proteogenomics-hla

Align to hg38 chr6 and extract reads within the HLA region:
```bash
sbatch \
    --array=436,437,439,440,447,448,450,451,452,455,459,462,470,471,473,475,478,480,603,604,606,607,608,609,611,612,613,616,667,669,670,672,673,5666%17 \
    scripts/get-hla-reads.sh
```

Run `xHLA` on each sample:
sbatch \
    --array=437,439,440,447,448,450,451,452,455,459,462,470,471,473,475,478,480,603,604,606,607,608,609,611,612,613,616,667,669,670,672,673,5666%5 \
    scripts/get-hla-type.sh

Combine `.json` files into [`HLA-types.tsv`](HLA-types.tsv):
```bash
module load R/4.3
Rscript scripts/collate-hla-types.sh
```