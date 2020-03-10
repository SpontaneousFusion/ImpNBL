# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


###
##
#
#
#
#     types:
#     1 - Main NBL
#     2 - NaI NBL
#     3 - HPGe NBL
#
##
###

# file.path="~/Dropbox/Bayesiansk statistikprojekt/Data/AUTOMORC_setups/setup1"
#
# NBL.type=1

fReadNBL=function(file.path,NBL.type=1)
{

  file.Main=paste0(file.path,".nbl")
  file.NaI=paste0(file.path,".nbl.NaI")
  file.HPGE=paste0(file.path,".nbl.HPGe")


  ##
  # reading the cordinates from the main file
  ##
  # file size in bytes bytes
  n = file.info(file.Main)$size/(304 * 2)
  file.connection = file(file.Main, "rb")
  coords <- matrix(nrow = n, ncol=2)
  start.times=matrix(nrow=n,ncol=1)
  spectra.Main=matrix(nrow=n,ncol=256)
  # i=1
  for(i in 1:n)
  {
    # readBin(file.connection,what= integer(), endian="little",size=1,n=8 + 4*4 + 2*2 + 2*2)
    readBin(file.connection,what= integer(), endian="little",size=1,n=4*2) # first integers
    readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    start.times[i,1]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    readBin(file.connection,what= integer(), endian="little",size=1,n= 2*2)
    readBin(file.connection,what= integer(), endian="little",size=1,n=2*2)
    coords[i, 2]= (180 / pi ) * readBin(file.connection,what= double(), endian="little",n=1)
    coords[i, 1]= (180 / pi ) * readBin(file.connection,what= double(), endian="little",n=1)
    readBin(file.connection,what= double(), endian="little",n=1)
    readBin(file.connection,what= integer(), endian="little",size=2,n=20)
    spectra.Main[i,]=readBin(file.connection,what= integer(), endian="little",size=2,n=256)
  }
  close(file.connection)



  spectra.HPGe = matrix( nrow = n, ncol = 2048)
  livetime.HPGe = matrix( nrow = n, ncol = 1)
  realtime.HPGe = matrix( nrow = n, ncol = 1)
  file.connection = file(file.HPGE, "rb")
  for(i in 1:n)
  {
    realtime.HPGe[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    livetime.HPGe[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    spectra.HPGe[i,]=readBin(file.connection,what= integer(), endian="little",size=2,n=2048)
  }
  close(file.connection)




  spectra.NaI = matrix( nrow = n, ncol = 256)
  livetime.NaI = matrix( nrow = n, ncol = 1)
  realtime.NaI = matrix( nrow = n, ncol = 1)
  file.connection = file(file.NaI, "rb")
  for(i in 1:n)
  {
    realtime.NaI[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    livetime.NaI[i]=readBin(file.connection,what= integer(), endian="little",size=4,n=1)
    spectra.NaI[i,]=readBin(file.connection,what= integer(), endian="little",size=2,n=256)
  }
  close(file.connection)






  if(NBL.type==1)
  {
    output=data.frame(coords,spectra.Main)
  }

  if(NBL.type==2)
  {
    output=data.frame(coords,spectra.NaI)
  }

  if(NBL.type==3)
  {
    output=data.frame(coords,spectra.HPGe)
  }



  return(output)
}
