#!/usr/bin/env nextflow

process PLOTCORRELATION {
    container "ghcr.io/bf528/deeptools:latest"
    label "process_medium"
    publishDir params.outdir

    input:
    path(npz)

    output:
    path("pearson_plot.png"), emit: plot

    shell:
    """
    plotCorrelation -in $npz -c pearson -p heatmap -o pearson_plot.png
    """
}
