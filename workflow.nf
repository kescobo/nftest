#!/usr/bin/env nextflow

workflow {
    inputs = Channel.
        fromFilePairs("testinput/*_{1,2}.txt").view()

    foo_out = foo(inputs)
    bar(foo_out[0], foo_out[1])
}

process foo {
  publishDir "./output", mode: 'symlink'
  
  input:
  tuple val(x), path(p)

  output:
  val x
  path "${x}_new.txt.gz"
  
  """
  echo $p
  cat $p > ${x}_new.txt
  gzip -k ${x}_new.txt
  """
}

process bar {
    publishDir "./output", mode: 'symlink'

    input:
    val x
    path file_from_prev

    output:
    path "${x}_decomp.txt"

    """
    gunzip -c $file_from_prev > ${x}_decomp.txt
    """
}