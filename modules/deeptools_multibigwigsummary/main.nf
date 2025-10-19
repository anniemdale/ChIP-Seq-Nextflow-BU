#!/usr/bin/env nextflow

process MULTIBIGWIGSUMMARY {
    container "ghcr.io/bf528/deeptools:latest"
    label "process_medium"
    publishDir params.outdir

    input:
    path(bigwigs)

    output:
    path("bw_all.npz"), emit: npz

    shell:
    """
    multiBigwigSummary bins -b  ${bigwigs.join(' ')} --labels ${bigwigs.baseName.join(' ')} -o bw_all.npz -p $task.cpus
    """
}

// --labels ${bigwigs.baseName.join(' ')}