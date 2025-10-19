#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    container "ghcr.io/bf528/deeptools:latest"
    label "process_high"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(bw)
    path(reference)

    output:
    tuple val(sample_id), path("*.gz"), emit: matrix

    shell:
    """
    computeMatrix scale-regions -S $bw -R $reference -a 2000 -b 2000 -o ${sample_id}_matrix.mat.gz
    """
}