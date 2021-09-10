BEGIN {
 tmp="                                                                          "
 i=0
}

{
 i++
 printf "sHelp[%4d] = '%s%s'\n",i,$0,substr(tmp,1,74-length())
}
