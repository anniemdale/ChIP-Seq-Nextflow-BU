#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    container "ghcr.io/bf528/samtools:latest"
    label "process_low"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(bam)

    output:
    path("${sample_id}_flagstat.txt"), emit: flagstat

    shell:
    """
    samtools flagstat -@ $task.cpus $bam > ${sample_id}_flagstat.txt
    """
}