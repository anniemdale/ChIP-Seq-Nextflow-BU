#!/usr/bin/env nextflow

process INTERSECT {
    container "ghcr.io/bf528/bedtools:latest"
    label "process_low"
    publishDir params.outdir

    input:
    path(bedA)
    path(bedB)

    output:
    path("repr_peaks.bed"), emit: intersect

    shell:
    """
    bedtools intersect -a $bedA -b $bedB -f 0.5 -r > repr_peaks.bed
    """
}