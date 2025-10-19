#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    container "ghcr.io/bf528/samtools:latest"
    label "process_high"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*sorted.bam"), emit: bam

    shell:
    """
    samtools sort -@ $task.cpus $bam > ${sample_id}.sorted.bam
    """
}