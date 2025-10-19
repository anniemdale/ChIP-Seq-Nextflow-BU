#!/usr/bin/env nextflow

process BAMCOVERAGE {
    container "ghcr.io/bf528/deeptools:latest"
    label "process_medium"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    tuple val(sample_id), path("*.bw"), emit: bigwig

    shell:
    """
    bamCoverage -b $bam -o ${sample_id}.bw -p $task.cpus
    """
}