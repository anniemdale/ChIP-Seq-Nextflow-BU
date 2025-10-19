#!/usr/bin/env nextflow

process MOTIFS {
    container "ghcr.io/bf528/homer:latest"
    label "process_medium"
    publishDir params.outdir

    input:
    path(filtered)
    path(genome)

    output:
    path('motifs/')

    shell:
    """
    findMotifsGenome.pl $filtered $genome motifs/ -size 200 -mask
    """
}