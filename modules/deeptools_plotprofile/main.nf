#!/usr/bin/env nextflow

process PLOTPROFILE {
    container "ghcr.io/bf528/deeptools:latest"
    label "process_low"
    publishDir params.outdir

    input:
    tuple val(sample_id), path(matrix)

    output:
    path("*profile_plot.png"), emit: profile

    shell:
    """
    plotProfile -m $matrix -o ${sample_id}_profile_plot.png
    """
}