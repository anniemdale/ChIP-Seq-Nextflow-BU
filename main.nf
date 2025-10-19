#!/usr/bin/env nextflow

include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIBIGWIGSUMMARY} from './modules/deeptools_multibigwigsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {CALLPEAK} from './modules/macs3_callpeak'
include {INTERSECT} from './modules/bedtools_intersect'
include {BLACKLIST} from './modules/bedtools_blacklist'
include {ANNOTATEPEAKS} from './modules/homer_annotatepeaks'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {MOTIFS} from './modules/homer_findmotifsgenome'

workflow {

    Channel.fromPath(params.samplesheet)
    | splitCsv(header: true)
    | map { row -> tuple(row.name, file(row.path))}
    | set {fastqc_ch}

    FASTQC(fastqc_ch)
    TRIM(fastqc_ch, params.adapter_fa)
    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(fastqc_ch, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out.bam)
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out.bam)
    BAMCOVERAGE(SAMTOOLS_IDX.out.index)

    multibwsummary_ch = BAMCOVERAGE.out.bigwig.map{it[1]}.collect() // to extract the filepath NOT label
    MULTIBIGWIGSUMMARY(multibwsummary_ch)

    PLOTCORRELATION(MULTIBIGWIGSUMMARY.out.npz)

   // BOWTIE2_ALIGN.out
    //| map {name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path])}
    //| groupTuple(by: 0)
    //| map {rep, maps -> tuple(rep, maps[0] + maps[1])}
    //| map {rep, samples -> tuple(rep, samples.IP, samples.INPUT)}
    //| set {peakcalling_ch}

    //CALLPEAK(peakcalling_ch)

    FASTQC.out.zip.mix(TRIM.out.log).mix(SAMTOOLS_FLAGSTAT.out.flagstat).collect()
    | set {multiqc_ch}

    MULTIQC(multiqc_ch)

    INTERSECT(params.peak1, params.peak2)
    BLACKLIST(INTERSECT.out.intersect, params.blacklist)
    ANNOTATEPEAKS(BLACKLIST.out.blacklist, params.genome, params.gtf)

    //multibwsummary_ch
    //| map { file -> tuple(file.findAll{it.baseName.startsWith("IP")}) }
    //| set { matrix_ch }
    BAMCOVERAGE.out.bigwig
    | filter { it[0].startsWith("IP") }
    | map { sample_id, bw -> tuple(sample_id, bw) }.collect()
    | set { matrix_ch }

    Channel.fromPath("refs/hg38_genes.bed")
    | set { reference_ch }

    COMPUTEMATRIX(matrix_ch, reference_ch)
    //COMPUTEMATRIX.out.matrix.view()

    PLOTPROFILE(COMPUTEMATRIX.out.matrix)

    MOTIFS(BLACKLIST.out.blacklist, params.genome)

}


// nextflow run main.nf -profile singularity,cluster -with-report -resume
resume = true