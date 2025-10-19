# ChIP-Seq-Nextflow-BU

## Project Title: ChIP-Seq Nextflow Pipeline Development
### Course: Translational Bioinformatics, BU (CDSBF 528)

### Project Description: 
Developed a full Nextflow pipeline for ChIP-Seq analysis of human breast cancer cell lines. This workflow includes QC, adapter trimming, alignment, peak calling, blacklist filtering, and motif discovery. Afterwards, we performed differential expression, peak annotation, and pathway enrichment to identify biologically relevant regulatory mechanisms.

### Software and Packages:
- Docker containers
- UCSC table browser
- Python: pandas, matplotlib
- FastQC
- Bowtie2
- Trimmomatic
- Samtools
- MultiQC
- Deeptools
- Macs3
- Bedtools
- Homer

### Files:
- subset_samplesheet.csv and full_samplesheet.csv point to where the samples are stored in our class’s folder
- refs/ folder contains the image from the UCSC table browser exploration as well as the outlined instructions for each week of the project
- envs/base_env.yml sets up the general environment to use nextflow
- envs/notebook_env.yml is specific to this project and setting up the python kernel to run the python notebook
- modules/ folder stores our individual nextflow components that are incorporated into the main.nf. These components define the hardware resources to be used, what the inputs and outputs must be, and the command line tool we are using.
- nextflow.config defines our parameters, so where different variables we call often are stored. It also defines our CPU levels that we specify for the various tools.

### Code Structure:
- main.nf is our workflow. Here all tools used are called and connected through a series of inputs and outputs.
- project2.ipynb is where we go over the figures provided by various tools and create figures to analyze our results and communicate our findings.

