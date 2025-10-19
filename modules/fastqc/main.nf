#!/usr/bin/env nextflow

process FASTQC {
    container "ghcr.io/bf528/fastqc:latest"
    label "process_low"
    publishDir params.outdir

    input:
    tuple val(name), path(fastq)

    output:
    tuple val(name), path("*.html")
    path("*.zip"), emit: zip

    shell:
    """
    fastqc -t $task.cpus ${fastq}
    """
}