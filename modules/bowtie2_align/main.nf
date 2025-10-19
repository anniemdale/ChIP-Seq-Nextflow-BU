#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    container "ghcr.io/bf528/bowtie2:latest"
    label "process_high"

    input:
    tuple val(sample_id), path(fastq)
    path index
    val name

    output:
    tuple val(sample_id), path("*.bam"), emit: bam

    shell:
    """
    bowtie2 -p 15 -x $index/$name -U $fastq | samtools view -bS > ${sample_id}.bam
    """
}