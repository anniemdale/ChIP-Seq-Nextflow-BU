#!/usr/bin/env nextflow

process BLACKLIST {
    container "ghcr.io/bf528/bedtools:latest"
    label "process_low"
    publishDir params.outdir

    input:
    path(repr_peaks)
    path(blacklist)

    output:
    path("refined_peaks.bed"), emit: blacklist

    shell:
    """
    bedtools intersect -v -a $repr_peaks -b $blacklist > refined_peaks.bed
    """
}