#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    container "ghcr.io/bf528/samtools:latest"
    label "process_single"

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path(bam), path("*.bai"), emit: index

    shell:
    """
    samtools index --threads $task.cpus $bam
    """
}