# proteogenomics-hla

## Set up `sambamba`

Ensure `sambamba` command is available, e.g. download the sambama/0.8.2 binary and move to a folder in `$PATH` like `~/.local/bin`
```bash
wget -O sambamba.gz \
    'https://github.com/biod/sambamba/releases/download/v0.8.2/sambamba-0.8.2-linux-amd64-static.gz'
gunzip sambamba.gz
chmod +x sambamba
mv sambamba ~/.local/bin
```

## Set up xHLA directory 
This directory only needs to be set up once, it will be copied 
```bash
git clone https://github.com/humanlongevity/HLA.git && cd HLA

# retrieve chr6 assembly for mapping (not included in xHLA repo)
esearch -db nucleotide -query 'NC_000006.12' | efetch -format fasta > data/chr6/hg38.chr6.fna

# modify header to match xHLA expectation
sed -i 's/^>.*$/>chr6/' data/chr6/hg38.chr6.fna && \
bwa index data/chr6/hg38.chr6.fna
```

## Set up data directory variable
Edit the variable `$DATADIR` within [`get-hla-reads.sh`](scripts/get-hla-reads.sh) to point to the directory containing sequencing reads (`fastq` files). In this case, `$DATADIR` points to `/data/CARD_proteomics/Psomagen/AN00022036`.


## Align reads
I aligned to hg38 chr6 and extracted reads within the HLA region with [`get-hla-reads.sh`](scripts/get-hla-reads.sh)
```bash
sbatch \
    --array=436,437,439,440,447,448,450,451,452,455,459,462,470,471,473,475,478,480,603,604,606,607,608,609,611,612,613,616,667,669,670,672,673,5666%17 \
    scripts/get-hla-reads.sh
```

## Run `xHLA`
The script [`get-hla-type.sh`](scripts/get-hla-type.sh) runs `xHLA` and is submitted as an array, one for each sample: 
```bash
sbatch \
    --array=437,439,440,447,448,450,451,452,455,459,462,470,471,473,475,478,480,603,604,606,607,608,609,611,612,613,616,667,669,670,672,673,5666%5 \
    scripts/get-hla-type.sh
```

## Combine results
All the  `.json` files are combined into [`HLA-types.tsv`](HLA-types.tsv) with [`collate-hla-types.sh`](scripts/)
```bash
module load R/4.3
Rscript scripts/collate-hla-types.sh
```