#!/usr/bin/env nextflow

process ANNOTATEPEAKS {
    container "ghcr.io/bf528/homer:latest"
    label "process_medium"
    publishDir params.outdir

    input:
    path(peaks)
    path(genome)
    path(gtf)

    output:
    path("annotated_peaks.txt"), emit: annotated

    shell:
    """
    annotatePeaks.pl $peaks $genome -gtf $gtf > annotated_peaks.txt
    """

}