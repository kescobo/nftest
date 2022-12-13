workflow {
    inputs = Channel.
        fromFilePairs("testinput/*_{1,2}.txt").view()

    foo(inputs)
}

process foo {
  publishDir "./output", mode: 'symlink'
  
  input:
  tuple val(x), path(p)

  output:
  path "${x}_new.txt"
  
  """
  cat $p > ${x}_new.txt
  """
}
